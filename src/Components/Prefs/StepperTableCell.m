#import "StepperTableCell.h"
#include <Foundation/Foundation.h>

@implementation SCIStepperTableCell

// PHVerticalAdjustmentTableCell'den uyarlandı
@dynamic control;

/* * PSTableCell * */

// Hücreyi stil ve yeniden kullanım tanımlayıcısıyla başlatır. 🛠️✨📱🔄
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
		self.accessoryView = self.control;
	}
	return self;
}

// Hücre içeriğini belirtici ile günceller. 🔄📊📝⚙️
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
	[super refreshCellContentsWithSpecifier:specifier];

    // Başlık şablonu henüz ayarlanmadıysa, mevcut metni kullan.
    if (!self.titleTemplate) {
        self.titleTemplate = self.textLabel.text;
    }

    self.control.minimumValue = ((NSNumber *)specifier.properties[PSControlMinimumKey]).doubleValue;
    self.control.maximumValue = ((NSNumber *)specifier.properties[PSControlMaximumKey]).doubleValue;
    self.control.stepValue = ((NSNumber *)specifier.properties[@"step"]).doubleValue;

	[self _updateLabel];
}

/* * PSControlTableCell * */

// Yeni bir UIStepper kontrolü oluşturur. ➕➖🆕⚙️
- (UIStepper *)newControl {
	UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];    
	stepper.continuous = NO; // Adım adım değişimi sağlar.

	return stepper;
}

// Kontrolün mevcut değerini döndürür. 🔢📈✨💾
- (NSNumber *)controlValue {
	return @(self.control.value);
}

// Kontrolün değerini ayarlar. 设定📊✍️🔄
- (void)setValue:(NSNumber *)value {
	[super setValue:value];
	self.control.value = value.doubleValue;
}

// Kontrol değeri değiştiğinde çağrılır. ✅🔄🔔👍
- (void)controlChanged:(UIStepper *)stepper {
	[super controlChanged:stepper];
	[self _updateLabel];
}

// Etiketi günceller. ✏️📝✨📐
- (void)_updateLabel {
	if (!self.control) {
		return;
	}

    double value = self.control.value;
        
    // Tekil veya çoğul etiketler için kontrol yapar.
    NSString *label;

    if (value == 1) {
        label = (NSString *)self.specifier.properties[@"singularLabel"];
    }
    else {
        label = (NSString *)self.specifier.properties[@"label"];
    }

    // Adım değerine göre doğru ondalık hassasiyetini belirler.
    NSUInteger valueDecimalPoints = [SCIUtils decimalPlacesInDouble:value];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:valueDecimalPoints ? NSNumberFormatterDecimalStyle : NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:valueDecimalPoints];
    [formatter setMinimumFractionDigits:0];

    NSString *stringValue = [formatter stringFromNumber:@(value)];

	self.textLabel.text = [NSString stringWithFormat:self.titleTemplate, stringValue, label];

	[self setNeedsLayout]; // Hücre düzeninin yeniden çizilmesini tetikler.
}
@end
