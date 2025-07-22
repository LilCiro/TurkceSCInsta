#import "SecurityViewController.h"

@implementation SCISecurityViewController

- (id)init {
    self = [super init];
    if (!self) return nil;

    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(authenticate)
        name:UIApplicationWillEnterForegroundNotification
        object:[UIApplication sharedApplication]
    ];

    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];
    
    UIButton *authenticateButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 200, 60)];
    [authenticateButton setTitle:@"Uygulamanın kilidini açmak için tıklayın" forState:UIControlStateNormal]; // Burası güncellendi
    authenticateButton.center = self.view.center;
    [authenticateButton addTarget:self action:@selector(authenticate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authenticateButton];
    
    [self authenticate];
}

- (void)authenticate {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;

    NSLog(@"[SCInsta] Kilit ekranı kimlik doğrulaması: Kilidi açmak için komut isteniyor. 🔐📱✨🔒"); // Burası güncellendi

    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        NSString *reason = @"Uygulamanın kilidini açmak için kimlik doğrulayın"; // Burası güncellendi
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:reason reply:^(BOOL success, NSError *authenticationError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [self dismissViewControllerAnimated:YES completion:nil];

                    isAuthenticationBeingShown = NO;

                    NSLog(@"[SCInsta] Kilit ekranı kimlik doğrulaması: Kilit başarıyla açıldı. ✅🔓🌟👍"); // Burası güncellendi
                }
                else {
                    NSLog(@"[SCInsta] Kilit ekranı kimlik doğrulaması: Kilit açma başarısız. ❌🚫🚨👎"); // Burası güncellendi
                }
            });
        }];
    }
    else {
        NSLog(@"[SCInsta] Kilit ekranı kimlik doğrulaması: Cihaz kimlik doğrulaması mevcut değil. ⚠️📵⛔❓"); // Burası güncellendi

        // Kullanıcıya bildir
        JGProgressHUD *HUD = [[JGProgressHUD alloc] init];
        HUD.textLabel.text = @"Kimlik doğrulama mevcut değil"; // Burası güncellendi
        HUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];

        [HUD showInView:topMostController().view];
        [HUD dismissAfterDelay:5.0];
    }
}

@end
