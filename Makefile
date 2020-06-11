INSTALL_TARGET_PROCESSES = Preferences
export ARCHS = arm64 arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SettingsWidgets

SettingsWidgets_FILES = Tweak.xm utils.m SWWidgetContainerView.m SWWidgetView.m SWBatteryWidgetView.m SWStorageWidgetView.m SWDiskUsageView.m SWWifiWidgetView.m SWCellularWidgetView.m
SettingsWidgets_CFLAGS = -fobjc-arc -O3
SettingsWidgets_FRAMEWORKS = IOKit
SettingsWidgets_PRIVATE_FRAMEWORKS = Preferences
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += settingswidgetsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
