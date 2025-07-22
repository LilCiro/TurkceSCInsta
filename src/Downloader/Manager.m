#import "Manager.h"

@implementation SCIDownloadManager

- (instancetype)initWithDelegate:(id<SCIDownloadDelegateProtocol>)downloadDelegate {
    self = [super init];

    if (self) {
        self.delegate = downloadDelegate;
    }

    return self;
}

- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension {
    // Özellikler
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.task = [self.session downloadTaskWithURL:url];

    // Geçerli bir uzantı sağlanmazsa varsayılan olarak jpg kullanılır
    self.fileExtension = [fileExtension length] >= 3 ? fileExtension : @"jpg";

    [self.task resume];
    [self.delegate downloadDidStart];
}

- (void)cancelDownload {
    [self.task cancel];
    [self.delegate downloadDidCancel];
}

// URLSession metotları
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    // Düzeltildi: Argümanlar eklendi
    NSLog(@"Görev %lld bayttan %lld bayt yazdı. 📦⬇️📊⚙️", totalBytesWritten, totalBytesExpectedToWrite);

    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;

    [self.delegate downloadDidProgress:progress];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // İndirilen dosyayı önbellek dizinine taşı
    NSURL *finalLocation = [self moveFileToCacheDir:location];

    [self.delegate downloadDidFinishWithFileURL:finalLocation];
}

// Düzeltildi: NSURLSessionSession yerine NSURLSession yazıldı ve argüman eklendi
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // Düzeltildi: Argüman eklendi
    NSLog(@"Görev şu hatayla tamamlandı: %@ 🛑❌🚨🐞", error.localizedDescription);

    [self.delegate downloadDidFinishWithError:error];
}

// İndirilen dosyayı yeniden adlandır ve belgeler dizininden önbellek dizinine taşı
- (NSURL *)moveFileToCacheDir:(NSURL *)oldPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *newPath = [[NSURL fileURLWithPath:cacheDirectoryPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, self.fileExtension]];

    // Düzeltildi: Argümanlar eklendi
    NSLog(@"[SCInsta] İndirme Yöneticisi: Dosya şuradan taşınıyor: %@ şuraya: %@ 🚚📂➡️💾", oldPath.lastPathComponent, newPath.lastPathComponent);

    // Dosyayı önbellek dizinine taşı
    NSError *fileMoveError;
    [fileManager moveItemAtURL:oldPath toURL:newPath error:&fileMoveError];

    if (fileMoveError) {
        // Düzeltildi: Argüman eklendi
        NSLog(@"[SCInsta] İndirme Yöneticisi: Dosya taşınırken hata oluştu: %@ ⚠️❌🐞🚨", fileMoveError.localizedDescription);
        // Düzeltildi: Argüman eklendi (eski 69. satırdaki sorun buydu)
        NSLog(@"[SCInsta] İndirme Yöneticisi: %@ 🐛🚫❓❗", fileMoveError.localizedDescription);
    }

    return newPath;
}

@end
