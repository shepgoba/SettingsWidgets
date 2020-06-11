
#import "SWWidgetContainerView.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "CoreTelephonyClient.h"

/**/
@interface CTDeviceDataUsage : NSObject
- (id)totalDataUsageForPeriod:(unsigned long long)arg1;
- (id)totalDataUsedForPeriod:(unsigned long long)arg1;
@end

@interface STCoreUser : NSObject
+ (id)fetchRequestMatchingAppleID:(id)arg1;
+ (id)fetchRequestForFamilyMembers;
+ (id)fetchRequestForUsersWithDSID:(id)arg1;
+ (id)fetchRequestMatchingLocalUser;
+ (id)fetchUserWithAppleID:(id)arg1 inContext:(id)arg2 error:(id *)arg3;
+ (id)fetchUserWithDSID:(id)arg1 inContext:(id)arg2 error:(id *)arg3;
+ (id)fetchLocalUserInContext:(id)arg1 error:(id *)arg2;
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

@interface PSURLManager : NSObject
+ (id)sharedManager;
- (void)processURL:(id)arg1 animated:(_Bool)arg2 fromSearch:(_Bool)arg3 withCompletion:(id)arg4;
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
	/*static NSMutableDictionary *settings;

	CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.shepgoba.settingswidgetsprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if (keyList) {
		settings = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, CFSTR("com.shepgoba.settingswidgetsprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else {
		settings = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.shepgoba.settingswidgetsprefs.plist"];
	}*/
	NSDictionary *settings = [[NSUserDefaults standardUserDefaults] persistentDomainForName: @"com.shepgoba.settingswidgetsprefs"];


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

%hook PSUIPrefsListController
%property (nonatomic, retain) SWWidgetContainerView *widgetContainerView;
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	UITableView *tblView = self.view.subviews[0];
	self.widgetContainerView.frame = CGRectMake(0, 0, tblView.frame.size.width, widgetHeight < MIN_WIDGET_HEIGHT ? MIN_WIDGET_HEIGHT : widgetHeight);
}
-(void)viewDidLoad {
	%orig;
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(pushStoragePrefsPage) name:@"SWPushStoragePage" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(pushBatteryPrefsPage) name:@"SWPushBatteryPage" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(pushWifiPrefsPage) name:@"SWPushWifiPage" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(pushCellularPrefsPage) name:@"SWPushCellularPage" object:nil];
	UITableView *tblView = self.view.subviews[0];

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
%new
-(void)pushStoragePrefsPage {
	//prefs:root=General&path=STORAGE_MGMT%23OFFLOAD

	[[%c(PSURLManager) sharedManager] processURL:[NSURL URLWithString:@"prefs:root=General&path=STORAGE_MGMT%23OFFLOAD"] animated: YES fromSearch:NO withCompletion:nil];
}
%new
-(void)pushBatteryPrefsPage {
	[[%c(PSURLManager) sharedManager] processURL:[NSURL URLWithString:@"prefs:root=BATTERY_USAGE"] animated: YES fromSearch:NO withCompletion:nil];
}
%new
-(void)pushWifiPrefsPage {
	[[%c(PSURLManager) sharedManager] processURL:[NSURL URLWithString:@"prefs:root=WIFI"] animated: YES fromSearch:NO withCompletion:nil];
}
%new
-(void)pushCellularPrefsPage {
	[[%c(PSURLManager) sharedManager] processURL:[NSURL URLWithString:@"prefs:root=MOBILE_DATA_SETTINGS_ID"] animated: YES fromSearch:NO withCompletion:nil];
}
%end


%ctor {
	loadPrefs();

	if (enabled)
		%init(_ungrouped);
}
