#import "../../Manager.h"
#import "../../Utils.h"

%hook IGDirectThreadCallButtonsCoordinator
// Sesli Arama
- (void)_didTapAudioButton:(id)arg1 {
    if ([SCIManager getBoolPref:@"call_confirm"]) {
        NSLog(@"[SCInsta] Çağrı onayı tetiklendi. 📞"); // Güncellendi

        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}

// Görüntülü Arama
- (void)_didTapVideoButton:(id)arg1 {
    if ([SCIManager getBoolPref:@"call_confirm"]) {
        NSLog(@"[SCInsta] Çağrı onayı tetiklendi. 📞"); // Güncellendi
        
        [SCIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end
