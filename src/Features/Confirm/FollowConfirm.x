#import "../../Manager.h"
#import "../../Utils.h"
#import "../../InstagramHeaders.h"

////////////////////////////////////////////////////////

#define CONFIRMFOLLOW(orig)                                                      \
    if ([SCIManager getBoolPref:@"follow_confirm"]) {                            \
        NSLog(@"[SCInsta] Takip onayı tetiklendi. 🤝✅🔒❗"); \
                                                                                 \
        [SCIUtils showConfirmation:^(void) { orig; }];                           \
    }                                                                            \
    else {                                                                       \
        return orig;                                                             \
    }                                                                            \

////////////////////////////////////////////////////////

// Profil sayfasındaki takip butonu
%hook IGFollowController
- (void)_didPressFollowButton {
    // Kullanıcının takip durumunu al (kullanıcıyı zaten takip edip etmediğini kontrol et)
    NSInteger UserFollowStatus = self.user.followStatus;

    // Sadece kullanıcı takip etmiyorsa onay iletişim kutusunu göster
    if (UserFollowStatus == 2) {
        CONFIRMFOLLOW(%orig);
    }
    else {
        return %orig;
    }
}
%end

// Keşfet sayfasındaki takip butonu
%hook IGDiscoverPeopleButtonGroupView
- (void)_onFollowButtonTapped:(id)arg1 {
    CONFIRMFOLLOW(%orig);
}
- (void)_onFollowingButtonTapped:(id)arg1 {
    CONFIRMFOLLOW(%orig);
}
%end

// Sizin için önerilenler (ana akış ve profil) takip butonu
%hook IGHScrollAYMFCell
- (void)_didTapAYMFActionButton {
    CONFIRMFOLLOW(%orig);
}
%end
%hook IGHScrollAYMFActionButton
- (void)_didTapTextActionButton {
    CONFIRMFOLLOW(%orig);
}
%end

// Reels'taki takip butonu
%hook IGUnifiedVideoFollowButton
- (void)_hackilyHandleOurOwnButtonTaps:(id)arg1 event:(id)arg2 {
    CONFIRMFOLLOW(%orig);
}
%end

// Profildeki takip yazısı (üst çubuğa daraldığında)
%hook IGProfileViewController
- (void)navigationItemsControllerDidTapHeaderFollowButton:(id)arg1 {
    CONFIRMFOLLOW(%orig);
}
%end

// Hikaye bölümündeki önerilen arkadaşlar takip butonu
%hook IGStorySectionController
- (void)followButtonTapped:(id)arg1 cell:(id)arg2 {
    CONFIRMFOLLOW(%orig);
}
%end
