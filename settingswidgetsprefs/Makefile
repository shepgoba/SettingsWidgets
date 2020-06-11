include $(THEOS)/makefiles/common.mk
TARGET = iphone:clang:11.2:11.0
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
