export THEOS_PACKAGE_SCHEME=rootless
export TARGET = iphone:clang:16.5:14.0
export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SettingsWidgets

SettingsWidgets_FILES = $(wildcard *.m) Tweak.xm
SettingsWidgets_CFLAGS = -fobjc-arc -O3
SettingsWidgets_FRAMEWORKS = Foundation UIKit IOKit
SettingsWidgets_PRIVATE_FRAMEWORKS = FrontBoardServices SpringBoardServices Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += swprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
