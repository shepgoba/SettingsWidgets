TARGET := iphone:clang:16.5:14.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = swprefs

swprefs_FILES = SWPRootListController.m
swprefs_FRAMEWORKS = UIKit
swprefs_PRIVATE_FRAMEWORKS = Preferences
swprefs_INSTALL_PATH = /Library/PreferenceBundles
swprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
