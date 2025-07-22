#import <UIKit/UIKit.h> // UIKit çatısı, UI bileşenleri için
#import "Utils.h"       // Kendi yardımcı fonksiyonlar başlık dosyamız
#import "InstagramHeaders.h" // Instagram'a özgü sınıf ve protokoller için

@implementation SCIUtils // SCIUtils sınıfının metodlarını tanımlar

// --- Renkler ---
// Ana rengi döndürür
+ (UIColor *)SCIColour_Primary {
    return [UIColor colorWithRed:0/255.0 green:152/255.0 blue:254/255.0 alpha:1];
}

// --- Hatalar ---
// Belirtilen açıklama ile bir hata nesnesi oluşturur
+ (NSError *)errorWithDescription:(NSString *)errorDesc {
    return [self errorWithDescription:errorDesc code:1]; // Varsayılan hata kodu 1
}
// Belirtilen açıklama ve hata kodu ile bir hata nesnesi oluşturur
+ (NSError *)errorWithDescription:(NSString *)errorDesc code:(NSInteger)errorCode {
    NSError *error = [ NSError errorWithDomain:@"com.socuul.scinsta" code:errorCode userInfo:@{ NSLocalizedDescriptionKey: errorDesc } ];
    return error;
}

// Belirtilen açıklama ile bir hata HUD (Heads-Up Display) gösterir
+ (JGProgressHUD *)showErrorHUDWithDescription:(NSString *)errorDesc {
    return [self showErrorHUDWithDescription:errorDesc dismissAfterDelay:4.0]; // Varsayılan gecikme 4 saniye
}
// Belirtilen açıklama ve gecikme ile bir hata HUD gösterir
+ (JGProgressHUD *)showErrorHUDWithDescription:(NSString *)errorDesc dismissAfterDelay:(CGFloat)dismissDelay {
    JGProgressHUD *hud = [[JGProgressHUD alloc] init]; // Yeni bir HUD oluştur
    hud.textLabel.text = errorDesc; // HUD'ın metnini ayarla
    hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init]; // Hata göstergesi kullan

    [hud showInView:topMostController().view]; // En üstteki kontrolcünün görünümünde HUD'ı göster
    [hud dismissAfterDelay:dismissDelay]; // Belirtilen gecikmeden sonra HUD'ı kapat

    return hud;
}

// --- Medya İşlemleri ---
// Bir fotoğraf nesnesinden en yüksek kaliteli URL'yi alır
+ (NSURL *)getPhotoUrl:(IGPhoto *)photo {
    if (!photo) return nil; // Fotoğraf yoksa nil döndür

    // En yüksek kaliteli fotoğraf bağlantısını al
    NSURL *photoUrl = [photo imageURLForWidth:100000.00]; // Yeterince büyük bir genişlik vererek en yükseği alır

    return photoUrl;
}
// Bir medya nesnesinden fotoğraf URL'sini alır
+ (NSURL *)getPhotoUrlForMedia:(IGMedia *)media {
    if (!media) return nil; // Medya yoksa nil döndür

    IGPhoto *photo = media.photo; // Medya nesnesindeki fotoğrafı al

    return [SCIUtils getPhotoUrl:photo]; // Fotoğrafın URL'sini döndür
}

// Bir video nesnesinden en yüksek kaliteli URL'yi alır
+ (NSURL *)getVideoUrl:(IGVideo *)video {
    if (!video) return nil; // Video yoksa nil döndür

    // Videoları kaliteye göre sırala
    NSArray<NSDictionary *> *sortedVideoUrls = [video sortedVideoURLsBySize];
    if ([sortedVideoUrls count] < 1 || sortedVideoUrls[0] == nil) return nil; // Video URL'si yoksa nil döndür

    // Dizideki ilk eleman en yüksek kalitedir
    NSURL *videoUrl = [NSURL URLWithString:[sortedVideoUrls[0] objectForKey:@"url"]];

    return videoUrl;
}
// Bir medya nesnesinden video URL'sini alır
+ (NSURL *)getVideoUrlForMedia:(IGMedia *)media {
    if (!media) return nil; // Medya yoksa nil döndür

    IGVideo *video = media.video; // Medya nesnesindeki videoyu al
    if (!video) return nil; // Video yoksa nil döndür

    return [SCIUtils getVideoUrl:video]; // Videonun URL'sini döndür
}

// --- View Controller İşlemleri ---
// Belirtilen görünüm (UIView) için view controller'ı bulur
+ (UIViewController *)viewControllerForView:(UIView *)view {
    NSString *viewDelegate = @"viewDelegate"; // Delegate metodunun adı
    if ([view respondsToSelector:NSSelectorFromString(viewDelegate)]) { // Metoda yanıt veriyorsa
        return [view valueForKey:viewDelegate]; // Değeri döndür
    }

    return nil; // Bulunamadıysa nil döndür
}

// Belirtilen görünümün atası olan view controller'ı bulur
+ (UIViewController *)viewControllerForAncestralView:(UIView *)view {
    NSString *_viewControllerForAncestor = @"_viewControllerForAncestor"; // Metodun adı
    if ([view respondsToSelector:NSSelectorFromString(_viewControllerForAncestor)]) { // Metoda yanıt veriyorsa
        return [view valueForKey:_viewControllerForAncestor]; // Değeri döndür
    }

    return nil; // Bulunamadıysa nil döndür
}

// Bir görünüme en yakın view controller'ı bulur
+ (UIViewController *)nearestViewControllerForView:(UIView *)view {
    // Önce doğrudan viewDelegate'i dene, yoksa ata view controller'ı dene
    return [self viewControllerForView:view] ?: [self viewControllerForAncestralView:view];
}

// --- Genel Fonksiyonlar ---
// Instagram uygulamasının sürüm dizesini döndürür
+ (NSString *)IGVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
// Cihazın çentikli olup olmadığını kontrol eder (iPhone X ve sonrası)
+ (BOOL)isNotch {
    // Safe area alt kenarının sıfırdan büyük olup olmadığını kontrol eder
    return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].bottom > 0;
}

// Belirtilen görünümde uzun basma hareket tanıyıcısı olup olmadığını kontrol eder
+ (BOOL)existingLongPressGestureRecognizerForView:(UIView *)view {
    NSArray *allRecognizers = view.gestureRecognizers; // Tüm hareket tanıyıcıları al

    for (UIGestureRecognizer *recognizer in allRecognizers) {
        if ([[recognizer class] isSubclassOfClass:[UILongPressGestureRecognizer class]]) { // UILongPressGestureRecognizer sınıfına ait veya alt sınıfıysa
            return YES; // Var demektir
        }
    }

    return NO; // Bulunamadı
}
// Bir eylemi onaylamak için bir alert penceresi gösterir
+ (BOOL)showConfirmation:(void(^)(void))okHandler {
    // UIAlertController'ın başlığını (title) 'nil' bırakarak daha sade bir görünüm elde edebiliriz,
    // ya da buraya "Onay Gerekli" gibi bir başlık ekleyebiliriz.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil // Başlık yok
                                                                   message:@"Emin misin?" // Mesaj metni
                                                            preferredStyle:UIAlertControllerStyleAlert]; // Alert stili kullan

    // "Evet" butonu: Tıklandığında okHandler'ı çalıştırır
    [alert addAction:[UIAlertAction actionWithTitle:@"Evet" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okHandler(); // Kullanıcı "Evet" derse, orijinal işlemi gerçekleştir
    }]];

    // "Hayır!" butonu: Tıklandığında sadece alert'i kapatır
    [alert addAction:[UIAlertAction actionWithTitle:@"Hayır!" style:UIAlertActionStyleCancel handler:nil]];

    // Alert'i en üstteki view controller üzerinde göster
    [topMostController() presentViewController:alert animated:YES completion:nil];

    return YES; // Onay penceresinin başarılı bir şekilde gösterildiğini belirtir
}
// Alert popover olarak gösteriliyorsa (iPad gibi) konumunu ayarlar
+ (void)prepareAlertPopoverIfNeeded:(UIAlertController*)alert inView:(UIView*)view {
    if (alert.popoverPresentationController) {
        // UIAlertController iPad'de bir popover olarak görüntülenir. Bir görünümün merkezinde gösterilmesini sağlar.
        alert.popoverPresentationController.sourceView = view; // Kaynak görünümü ayarla
        alert.popoverPresentationController.sourceRect = CGRectMake(view.bounds.size.width / 2.0, view.bounds.size.height / 2.0, 1.0, 1.0); // Merkezden başla
        alert.popoverPresentationController.permittedArrowDirections = 0; // Ok yönlerini kapat (ortada görüntülemek için)
    }
}

// --- Matematiksel Fonksiyonlar ---
// Bir double değerindeki ondalık basamak sayısını hesaplar
+ (NSUInteger)decimalPlacesInDouble:(double)value {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:15]; // Double hassasiyeti için yeterli sayıda basamağa izin ver
    [formatter setMinimumFractionDigits:0]; // Minimum ondalık basamak yok
    [formatter setDecimalSeparator:@"."]; // Dahili mantık için ondalık ayırıcıyı noktaya zorla

    NSString *stringValue = [formatter stringFromNumber:@(value)]; // Double değeri dizeye çevir

    // Ondalık ayırıcıyı bul
    NSRange decimalRange = [stringValue rangeOfString:formatter.decimalSeparator];

    if (decimalRange.location == NSNotFound) { // Ondalık ayırıcı yoksa
        return 0; // Sıfır ondalık basamak
    } else {
        // Toplam uzunluktan ondalık ayırıcıya kadar olan kısmı çıkar
        return stringValue.length - (decimalRange.location + decimalRange.length);
    }
}

@end // SCIUtils sınıf tanımının sonu
