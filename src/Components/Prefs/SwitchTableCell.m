#import "SwitchTableCell.h"

@implementation SCISwitchTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier])) {
        NSString *subTitle = [specifier.properties[@"subtitle"] copy]; // Alt başlık metnini kopyalar. 📝
        BOOL isBig = specifier.properties[@"big"] ? ((NSNumber *)specifier.properties[@"big"]).boolValue : NO; // Alt başlığın çok satırlı olup olmayacağını belirler. 📏
        self.detailTextLabel.text = subTitle; // Alt başlık etiketinin metnini ayarlar. 💬
        self.detailTextLabel.numberOfLines = isBig ? 0 : 1; // Alt başlık etiketinin satır sayısını ayarlar. ↕️
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor]; // Alt başlık etiketinin metin rengini ayarlar. 🎨

        UISwitch *targetSwitch = ((UISwitch *)[self control]); // Hücredeki anahtar (switch) kontrolünü alır. 💡
        [targetSwitch setOnTintColor:[SCIUtils SCIColour_Primary]]; // Anahtar açıkken rengini ayarlar. ✨
        
        if (specifier.properties[@"switchAction"]) { // Eğer özel bir anahtar eylemi tanımlanmışsa. ⚙️
            NSString *strAction = [specifier.properties[@"switchAction"] copy]; // Eylem adını kopyalar. 🚀
            // Anahtar değeri değiştiğinde belirlenen eylemi hedef (target) üzerinde çağırır. 🔔
            [targetSwitch addTarget:[self cellTarget] action:NSSelectorFromString(strAction) forControlEvents:UIControlEventValueChanged]; 
        }
    }
    return self;
}
@end
