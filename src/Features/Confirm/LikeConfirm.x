#import "../../Manager.h"
#import "../../Utils.h"
#import "../../InstagramHeaders.h"

///////////////////////////////////////////////////////////

// Onay işleyiciler

#define CONFIRMPOSTLIKE(orig)                                                   \
    if ([SCIManager getBoolPref:@"like_confirm"]) {                             \
        NSLog(@"[SCInsta] Gönderi beğenme onayı. ❤️👍✅🔒");                   \
        [SCIUtils showConfirmation:^(void) { orig; }];                          \
    }                                                                           \
    else {                                                                      \
        return orig;                                                            \
    }

#define CONFIRMREELSLIKE(orig)                                                  \
    if ([SCIManager getBoolPref:@"like_confirm_reels"]) {                       \
        NSLog(@"[SCInsta] Reels beğenme onayı. 🎬❤️✅🔒");                    \
        [SCIUtils showConfirmation:^(void) { orig; }];                          \
    }                                                                           \
    else {                                                                      \
        return orig;                                                            \
    }

///////////////////////////////////////////////////////////

// Gönderileri beğenme
%hook IGUFIButtonBarView
- (void)_onLikeButtonPressed:(id)arg1 {
    CONFIRMPOSTLIKE(%orig);
}
%end
%hook IGFeedPhotoView
- (void)_onDoubleTap:(id)arg1 {
    CONFIRMPOSTLIKE(%orig);
}
%end
%hook IGVideoPlayerOverlayContainerView
- (void)_handleDoubleTapGesture:(id)arg1 {
    CONFIRMPOSTLIKE(%orig);
}
%end
%hook IGFeedItemUFICell
- (void)UFIButtonBarDidTapOnLike:(id)arg1 {
    CONFIRMPOSTLIKE(%orig);
}
%end

// Reels'ı beğenme
%hook IGSundialViewerVideoCell
- (void)controlsOverlayControllerDidTapLikeButton:(id)arg1 {
    CONFIRMREELSLIKE(%orig);
}
- (void)controlsOverlayControllerDidLongPressLikeButton:(id)arg1 gestureRecognizer:(id)arg2 {
    CONFIRMREELSLIKE(%orig);
}
- (void)gestureController:(id)arg1 didObserveDoubleTap:(id)arg2 {
    CONFIRMREELSLIKE(%orig);
}
%end
%hook IGSundialViewerPhotoCell
- (void)controlsOverlayControllerDidTapLikeButton:(id)arg1 {
    CONFIRMREELSLIKE(%orig);
}
- (void)gestureController:(id)arg1 didObserveDoubleTap:(id)arg2 {
    CONFIRMREELSLIKE(%orig);
}
%end
%hook IGSundialViewerCarouselCell
- (void)controlsOverlayControllerDidTapLikeButton:(id)arg1 {
    CONFIRMREELSLIKE(%orig);
}
- (void)gestureController:(id)arg1 didObserveDoubleTap:(id)arg2 { // BURASI DÜZELTİLDİ! arg1 -> arg2
    CONFIRMREELSLIKE(%orig);
}
%end

// Yorumları beğenme
%hook IGCommentCellController
- (void)commentCell:(id)arg1 didTapLikeButton:(id)arg2 {
    CONFIRMPOSTLIKE(%orig);
}
- (void)commentCell:(id)arg1 didTapLikedByButtonForUser:(id)arg2 {
    CONFIRMPOSTLIKE(%orig);
}
- (void)commentCellDidLongPressOnLikeButton:(id)arg1 {
    CONFIRMPOSTLIKE(%orig);
}
- (void)commentCellDidEndLongPressOnLikeButton:(id)arg1 {
    CONFIRMPOSTLIKE(%orig);
}
- (void)commentCellDidDoubleTap:(id)arg1 {
    CONFIRMPOSTLIKE(%orig);
}
%end
%hook IGFeedItemPreviewCommentCell
- (void)_didTapLikeButton {
    CONFIRMPOSTLIKE(%orig);
}
%end

// Hikayeleri beğenme
%hook IGStoryFullscreenDefaultFooterView
- (void)_handleLikeTapped {
    CONFIRMPOSTLIKE(%orig);
}
- (void)_likeTapped {
    CONFIRMPOSTLIKE(%orig);
}
- (void)inputView:(id)arg1 didTapLikeButton:(id)arg2 {
    CONFIRMPOSTLIKE(%orig);
}
%end

// DM beğen butonu (gizli gibi görünüyor)
%hook IGDirectThreadViewController
- (void)_didTapLikeButton {
    CONFIRMPOSTLIKE(%orig);
}
%end
