#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// SCIDownloadDelegateProtocol: İndirme olaylarını dinlemek için protokol
@protocol SCIDownloadDelegateProtocol <NSObject>

// Metotlar
- (void)downloadDidStart; // İndirme başladığında çağrılır 🚀
- (void)downloadDidCancel; // İndirme iptal edildiğinde çağrılır ❌
- (void)downloadDidProgress:(float)progress; // İndirme ilerledikçe çağrılır 📊
- (void)downloadDidFinishWithError:(NSError *)error; // İndirme hatayla tamamlandığında çağrılır 🚨
- (void)downloadDidFinishWithFileURL:(NSURL *)fileURL; // İndirme başarıyla tamamlandığında dosya URL'si ile çağrılır ✅

@end

// SCIDownloadManager: Dosya indirme işlemlerini yöneten sınıf
@interface SCIDownloadManager : NSObject <NSURLSessionDownloadDelegate>

// Özellikler
@property (nonatomic, weak) id<SCIDownloadDelegateProtocol> delegate; // İndirme olaylarını dinleyecek delege 🤝
@property (nonatomic, strong) NSURLSession *session; // URL oturumu 🌐
@property (nonatomic, strong) NSURLSessionDownloadTask *task; // İndirme görevi ⬇️
@property (nonatomic, strong) NSString *fileExtension; // İndirilen dosyanın uzantısı 📄

// Metotlar
- (instancetype)initWithDelegate:(id<SCIDownloadDelegateProtocol>)downloadDelegate; // Delege ile başlatıcı 🛠️

- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension; // Belirtilen URL'den dosyayı indirir 📥

- (void)cancelDownload; // Devam eden indirme işlemini iptal eder 🛑

- (NSURL *)moveFileToCacheDir:(NSURL *)oldPath; // İndirilen dosyayı önbellek dizinine taşır 📁

@end
