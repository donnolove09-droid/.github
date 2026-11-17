TARGET := iphone:clang:latest:14.0
ARCHS := arm64
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ASNLIGHT
ASNLIGHT_FILES = Tweak.xm
ASNLIGHT_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
ASNLIGHT_FRAMEWORKS = UIKit Foundation
ASNLIGHT_PRIVATE_FRAMEWORKS =

include $(THEOS_MAKE_PATH)/tweak.mk
