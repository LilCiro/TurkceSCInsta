TARGET := iphone:clang:17.2
INSTALL_TARGET_PROCESSES = Instagram
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SCInsta

$(TWEAK_NAME)_FILES = $(shell find src -type f \( -iname \*.x -o -iname \*.xm -o -iname \*.m \)) $(wildcard modules/JGProgressHUD/*.m)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation CoreGraphics Photos CoreServices SystemConfiguration SafariServices Security QuartzCore Preferences
# Eski private frameworks satırını yoruma alabilirsin.
# $(TWEAK_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs CepheiUI
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wno-unsupported-availability-guard -Wno-unused-value -Wno-deprecated-declarations -Wno-nullability-completeness -Wno-unused-function -Wno-incompatible-pointer-types
$(TWEAK_NAME)_LOGOSFLAGS = --c warnings=none

CCFLAGS += -std=c++11

# Theos'a özel framework başlıklarının nerede olduğunu söyleyen satır
THEOS_PRIVATE_FRAMEWORK_HEADERS = $(THEOS)/sdks/path/to/private/headers

include $(THEOS_MAKE_PATH)/tweak.mk

# Dev mode (skip building FLEX)
ifdef DEV
	$(TWEAK_NAME)_SUBPROJECTS += modules/sideloadfix
else

	ifdef SIDELOAD
		$(TWEAK_NAME)_SUBPROJECTS += modules/sideloadfix modules/flexing
	else
		$(TWEAK_NAME)_SUBPROJECTS += modules/flexing
	endif

endif
