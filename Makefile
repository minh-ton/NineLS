TARGET := iphone:clang::13.3
ARCHS = arm64 arm64e
DEBUG=0

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NineLS

NineLS_FILES = support/MarqueeLabel.m NineLS.xm
NineLS_CFLAGS = -fobjc-arc
NineLS_FRAMEWORKS = UIKit
NineLS_PRIVATE_FRAMEWORKS = MediaRemote
NineLS_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
