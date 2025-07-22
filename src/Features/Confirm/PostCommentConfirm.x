#import "../../Manager.h"
#import "../../Utils.h"

%hook IGCommentComposer.IGCommentComposerController
- (void)onSendButtonTap {
    if ([SCIManager getBoolPref:@"post_comment_confirm"]) {
        NSLog(@"[SCInsta] Yorum gönderme onayı. 💬✍️✅🔒");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end
