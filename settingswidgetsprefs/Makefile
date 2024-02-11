include $(THEOS)/makefiles/common.mk
export THEOS_PACKAGE_SCHEME=rootless
TARGET = iphone:clang:16.5:14.0
BUNDLE_NAME = settingswidgetsprefs

settingswidgetsprefs_FILES = SWPRootListController.m
settingswidgetsprefs_INSTALL_PATH = /Library/PreferenceBundles
settingswidgetsprefs_FRAMEWORKS = UIKit
settingswidgetsprefs_PRIVATE_FRAMEWORKS = Preferences
settingswidgetsprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/settingswidgetsprefs.plist$(ECHO_END)
