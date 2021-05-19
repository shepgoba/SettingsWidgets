TARGET := iphone:clang:latest:7.0

INSTALL_TARGET_PROCESSES = Preferences
export ARCHS = arm64 arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SettingsWidgets

SettingsWidgets_FILES = $(wildcard *.m) Tweak.xm
SettingsWidgets_CFLAGS = -fobjc-arc -O3
SettingsWidgets_FRAMEWORKS = Foundation UIKit IOKit
SettingsWidgets_PRIVATE_FRAMEWORKS = FrontBoardServices SpringBoardServices InstallCoordination Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += settingswidgetsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
