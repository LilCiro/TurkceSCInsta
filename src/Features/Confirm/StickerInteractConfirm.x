#import "../../Manager.h"
#import "../../Utils.h"

%hook IGStoryViewerTapTarget
- (void)_didTap:(id)arg1 forEvent:(id)arg2 {
    if ([SCIManager getBoolPref:@"sticker_interact_confirm"]) {
        NSLog(@"[SCInsta] Çıkartma etkileşim onayı. 🏷️👆✅🔒");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end
