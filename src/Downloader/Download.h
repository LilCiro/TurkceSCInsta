#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "../../modules/JGProgressHUD/JGProgressHUD.h" // JGProgressHUD modülünü içe aktar

#import "../InstagramHeaders.h" // Instagram başlık dosyalarını içe aktar
#import "../Manager.h" // Manager sınıfını içe aktar
#import "../Utils.h" // Yardımcı (Utils) sınıfını içe aktar

#import "Manager.h" // Muhtemelen SCIDownloadManager'ı tanımlayan Manager.h'ı tekrar içe aktarır

// SCIDownloadDelegate: İndirme işlemlerini delege olarak yöneten sınıf
@interface SCIDownloadDelegate : NSObject <SCIDownloadDelegateProtocol>

// İndirme tamamlandığında gerçekleştirilecek eylemleri tanımlar
typedef NS_ENUM(NSUInteger, DownloadAction) {
    share,     // Paylaşma eylemi 📤
    quickLook  // Hızlı bakış eylemi 👁️
};

// Özellikler
@property (nonatomic, readonly) DownloadAction action; // İndirme sonrası gerçekleştirilecek eylem (sadece okunabilir) 🚀
@property (nonatomic, readonly) BOOL showProgress; // İlerleme göstergesinin gösterilip gösterilmeyeceği (sadece okunabilir) 📊

@property (nonatomic, strong) SCIDownloadManager *downloadManager; // İndirme işlemlerini yöneten manager 📥
@property (nonatomic, strong) JGProgressHUD *hud; // İlerleme göstergesi HUD'u ✨

// Başlatıcı
- (instancetype)initWithAction:(DownloadAction)action showProgress:(BOOL)showProgress; // Belirtilen eylem ve ilerleme gösterme durumuyla başlatır 🛠️

// Metot
- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension hudLabel:(NSString *)hudLabel; // Belirtilen URL'den dosyayı indirir, dosya uzantısı ve HUD etiketiyle ⬇️
@end
