#import <CepheiPrefs/CepheiPrefs.h> // CepheiPrefs kütüphanesini içe aktarır (Ayarlar paneli geliştirmek için kullanılır) ⚙️
#include <Foundation/Foundation.h> // Temel nesne ve veri türlerini içeren Foundation kütüphanesini içe aktarır 📚

#import "../../Manager.h" // Uygulamanın genel yöneticisi (Manager) sınıfını içe aktarır 🚀
#import "../../Utils.h" // Yardımcı (Utils) fonksiyonları içeren sınıfı içe aktarır 🔧

#import "StepperTableCell.h" // Kendi tanımladığımız StepperTableCell başlık dosyasını içe aktarır 📱

// SCIStepperTableCell arayüz tanımı: PSControlTableCell'den türetilmiştir
@interface SCIStepperTableCell : PSControlTableCell

// Özellikler
@property (nonatomic, retain) UIStepper *control; // Hücre içinde kullanılacak UIStepper kontrolü ➕➖
@property (nonatomic, retain) NSString *titleTemplate; // Hücre başlığının şablonu (örneğin "%@ saniye") 📝

@end
