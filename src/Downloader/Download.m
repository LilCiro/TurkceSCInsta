#import "Download.h"

@implementation SCIDownloadDelegate

- (instancetype)initWithAction:(DownloadAction)action showProgress:(BOOL)showProgress {
    self = [super init];
    
    if (self) {
        // Read-only properties
        _action = action;
        _showProgress = showProgress;

        // Properties
        self.downloadManager = [[SCIDownloadManager alloc] initWithDelegate:self];
        self.hud = [[JGProgressHUD alloc] init];
    }

    return self;
}
- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension hudLabel:(NSString *)hudLabel {
    // Show progress gui
    self.hud = [[JGProgressHUD alloc] init];
    self.hud.textLabel.text = hudLabel != nil ? hudLabel : @"İndiriliyor... ⬇️"; // Burası güncellendi

    if (self.showProgress) {
        JGProgressHUDRingIndicatorView *indicatorView = [[JGProgressHUDRingIndicatorView alloc] init ];
        indicatorView.roundProgressLine = YES;
        indicatorView.ringWidth = 3.5;

        self.hud.indicatorView = indicatorView;
        self.hud.detailTextLabel.text = [NSString stringWithFormat:@"00%% Tamamlandı ✅"]; // Burası güncellendi

        // Allow dismissing longer downloads (requiring progress updates)
        __weak typeof(self) weakSelf = self;
        self.hud.tapOutsideBlock = ^(JGProgressHUD * _Nonnull HUD) {
            [weakSelf.downloadManager cancelDownload];
        };
    }

    [self.hud showInView:topMostController().view];

    NSLog(@"[SCInsta] İndirme: \"%@\" URL'sinden \".%@\" dosya uzantısıyla indirme başlatılacak. 🚀", url, fileExtension); // Burası güncellendi

    // Start download using manager
    [self.downloadManager downloadFileWithURL:url fileExtension:fileExtension];
}

// Delegate methods
- (void)downloadDidStart {
    NSLog(@"[SCInsta] İndirme: İndirme başladı. ▶️"); // Burası güncellendi
}
- (void)downloadDidCancel {
    [self.hud dismiss];

    NSLog(@"[SCInsta] İndirme: İndirme iptal edildi. ❌"); // Burası güncellendi
}
- (void)downloadDidProgress:(float)progress {
    NSLog(@"[SCInsta] İndirme: İndirme ilerlemesi: %f 📊", progress); // Burası güncellendi
    
    if (self.showProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud setProgress:progress animated:false];
            self.hud.detailTextLabel.text = [NSString stringWithFormat:@"%02d%% Tamamlandı ✅", (int)(progress * 100)]; // Burası güncellendi
        });
    }
}
- (void)downloadDidFinishWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Check if it actually errored (not cancelled)
        if (error && error.code != NSURLErrorCancelled) {
            NSLog(@"[SCInsta] İndirme: \"%@\" hatasıyla indirme başarısız oldu. 🚫", error); // Burası güncellendi
            [SCIUtils showErrorHUDWithDescription:@"Hata oluştu, lütfen daha sonra tekrar deneyin ⚠️"]; // Burası güncellendi
        }
    });
}
- (void)downloadDidFinishWithFileURL:(NSURL *)fileURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud dismiss];

        NSLog(@"[SCInsta] İndirme: \"%@\" URL'si ile indirme tamamlandı. ✨", [fileURL absoluteString]); // Burası güncellendi
        NSLog(@"[SCInsta] İndirme: %d eylemiyle tamamlandı. 🎉", (int)self.action); // Burası güncellendi

        switch (self.action) {
            case share:
                [SCIManager showShareVC:fileURL];
                break;
            
            case quickLook:
                [SCIManager showQuickLookVC:@[fileURL]];
                break;
        }
    });
}

@end
