TARGET := iphone:clang::13.3
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NineLSPref

NineLSPref_FILES = $(wildcard *.m)
NineLSPref_FRAMEWORKS = UIKit
NineLSPref_PRIVATE_FRAMEWORKS = Preferences
NineLSPref_INSTALL_PATH = /Library/PreferenceBundles
NineLSPref_CFLAGS = -fobjc-arc
NineLSPref_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
NineLSPref_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk
