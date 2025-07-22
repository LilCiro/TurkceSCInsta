#import "../../Manager.h"
#import "../../Utils.h"

%hook IGDirectThreadViewController
- (void)swipeableScrollManagerDidEndDraggingAboveSwipeThreshold:(id)arg1 {
    if ([SCIManager getBoolPref:@"shh_mode_confirm"]) {
        NSLog(@"[SCInsta] Sessiz mod onayı. 🤫💬✅🔒");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}

- (void)shhModeTransitionButtonDidTap:(id)arg1 {
    if ([SCIManager getBoolPref:@"shh_mode_confirm"]) {
        NSLog(@"[SCInsta] Sessiz mod onayı. 🤫💬✅🔒");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}

- (void)messageListViewControllerDidToggleShhMode:(id)arg1 {
    if ([SCIManager getBoolPref:@"shh_mode_confirm"]) {
        NSLog(@"[SCInsta] Sessiz mod onayı. 🤫💬✅🔒");

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end
