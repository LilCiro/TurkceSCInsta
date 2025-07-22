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
    // Properties
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.task = [self.session downloadTaskWithURL:url];
    
    // Default to jpg if no other reasonable length extension is provided
    self.fileExtension = [fileExtension length] >= 3 ? fileExtension : @"jpg";

    [self.task resume];
    [self.delegate downloadDidStart];
}

- (void)cancelDownload {
    [self.task cancel];
    [self.delegate downloadDidCancel];
}

// URLSession methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"Görev %lld bayttan %lld bayt yazdı. 📦", bytesWritten, totalBytesExpectedToWrite); // Burası güncellendi
    
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;

    [self.delegate downloadDidProgress:progress];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {    
    // Move downloaded file to cache directory
    NSURL *finalLocation = [self moveFileToCacheDir:location];

    [self.delegate downloadDidFinishWithFileURL:finalLocation];
}

- (void)URLSession:(NSURLSessionSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"Görev şu hatayla tamamlandı: %@ 🛑", error); // Burası güncellendi
    
    [self.delegate downloadDidFinishWithError:error];
}

// Rename downloaded file & move from documents dir -> cache dir
- (NSURL *)moveFileToCacheDir:(NSURL *)oldPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *newPath = [[NSURL fileURLWithPath:cacheDirectoryPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, self.fileExtension]];
    
    NSLog(@"[SCInsta] İndirme Yöneticisi: Dosya şuradan taşınıyor: %@ şuraya: %@ 🚚", oldPath.absoluteString, newPath.absoluteString); // Burası güncellendi

    // Move file to cache directory
    NSError *fileMoveError;
    [fileManager moveItemAtURL:oldPath toURL:newPath error:&fileMoveError];

    if (fileMoveError) {
        NSLog(@"[SCInsta] İndirme Yöneticisi: Dosya taşınırken hata oluştu: %@ ⚠️", oldPath.absoluteString); // Burası güncellendi
        NSLog(@"[SCInsta] İndirme Yöneticisi: %@ 🐞", fileMoveError); // Burası güncellendi
    }

    return newPath;
}

@end
