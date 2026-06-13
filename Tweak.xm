#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SWWidgetContainerView.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "CoreTelephonyClient.h"


@interface CTDeviceDataUsage : NSObject
- (id)totalDataUsageForPeriod:(unsigned long long)arg1;
- (id)totalDataUsedForPeriod:(unsigned long long)arg1;
@end


extern "C"
int __isOSVersionAtLeast(int major, int minor, int patch) {
	NSOperatingSystemVersion version;
	version.majorVersion = major;
	version.minorVersion = minor;
	version.patchVersion = patch;
	return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
}


#define MIN_WIDGET_HEIGHT 100

@interface UITraitCollection (iOS13)
+(UITraitCollection *)currentTraitCollection;
@end


static BOOL boolForKey(NSDictionary *dict, NSString *key, BOOL fallBack) {
	id result = [dict objectForKey:key];
	
	if (!result) {
		return fallBack;
	}
	return [result boolValue];
}

static SWWidgetType widgetTypeForKey(NSDictionary *dict, NSString *key, SWWidgetType fallBack) {
	id result = [dict objectForKey:key];

	if (!result) {
		return fallBack;
	}
	return (SWWidgetType)[result integerValue];
}

static int intForKey(NSDictionary *dict, NSString *key, long long fallBack) {
	id result = [dict objectForKey:key];

	if (!result) {
		return fallBack;
	}
	return [result intValue];
}


static BOOL enabled;
static BOOL transparentMode;
static BOOL widget2Enabled;
static int widgetCornerRadius;
static int widgetHeight;
static int widgetInset;
static SWWidgetType widgetType1;
static SWWidgetType widgetType2;


static void loadPrefs() {
	NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.shepgoba.swprefs"];
	NSDictionary *settings = defaults.dictionaryRepresentation;

  	enabled = boolForKey(settings, @"enabled", YES);
	transparentMode = boolForKey(settings, @"transparentMode", NO);
	widgetType1 = widgetTypeForKey(settings, @"widgetType1", SWWidgetTypeBattery);
	widgetType2 = widgetTypeForKey(settings, @"widgetType2", SWWidgetTypeStorage);
	widgetHeight = intForKey(settings, @"widgetHeight", 120);
	widgetInset = intForKey(settings, @"widgetInset", 15);
	widget2Enabled = boolForKey(settings, @"widget2Enabled", YES);
	widgetCornerRadius = intForKey(settings, @"widgetCornerRadius", 16);
}

@interface PSUIPrefsListController : PSListController
@property (nonatomic, retain) SWWidgetContainerView *widgetContainerView;
- (id)specifierForID;
@end


%group Tweak
%hook PSUIPrefsListController
%property (nonatomic, retain) SWWidgetContainerView *widgetContainerView;
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	UITableView *tblView = self.table;
	self.widgetContainerView.frame = CGRectMake(0, 0, tblView.frame.size.width, widgetHeight < MIN_WIDGET_HEIGHT ? MIN_WIDGET_HEIGHT : widgetHeight);
}
-(void)viewDidLoad {
	%orig;

	UITableView *tblView = self.table;

	self.widgetContainerView = [[SWWidgetContainerView alloc] init];
	self.widgetContainerView.backgroundColor = UIColor.clearColor;

	tblView.tableHeaderView = self.widgetContainerView;

	if (!widget2Enabled)
		widgetType2 = SWWidgetTypeNone;

	[self.widgetContainerView setupWidgetsWithType1:widgetType1 type2:widgetType2 transparentBackground:transparentMode widgetInset:widgetInset cornerRadius:widgetCornerRadius];
	[self.widgetContainerView setWidgetBackgrounds];

}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	%orig;
	[self.widgetContainerView setWidgetBackgrounds];
}

%end
%end

%ctor {
	NSLog(@"SettingsWidgets loaded");
	loadPrefs();
	if (enabled)
		%init(Tweak);
}
