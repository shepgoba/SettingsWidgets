#line 1 "Tweak.xm"

#import "SWWidgetContainerView.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import "CoreTelephonyClient.h"


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


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class PSURLManager; @class PSUIPrefsListController; 
static void (*_logos_orig$_ungrouped$PSUIPrefsListController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$PSUIPrefsListController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$PSUIPrefsListController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$PSUIPrefsListController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$PSUIPrefsListController$traitCollectionDidChange$)(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UITraitCollection *); static void _logos_method$_ungrouped$PSUIPrefsListController$traitCollectionDidChange$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UITraitCollection *); static void _logos_method$_ungrouped$PSUIPrefsListController$pushStoragePrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$PSUIPrefsListController$pushBatteryPrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$PSUIPrefsListController$pushWifiPrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$PSUIPrefsListController$pushCellularPrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$PSURLManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("PSURLManager"); } return _klass; }
#line 109 "Tweak.xm"

__attribute__((used)) static SWWidgetContainerView * _logos_method$_ungrouped$PSUIPrefsListController$widgetContainerView(PSUIPrefsListController * __unused self, SEL __unused _cmd) { return (SWWidgetContainerView *)objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$PSUIPrefsListController$widgetContainerView); }; __attribute__((used)) static void _logos_method$_ungrouped$PSUIPrefsListController$setWidgetContainerView(PSUIPrefsListController * __unused self, SEL __unused _cmd, SWWidgetContainerView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$PSUIPrefsListController$widgetContainerView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
static void _logos_method$_ungrouped$PSUIPrefsListController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
	_logos_orig$_ungrouped$PSUIPrefsListController$viewWillAppear$(self, _cmd, arg1);
	UITableView *tblView = self.view.subviews[0];
	self.widgetContainerView.frame = CGRectMake(0, 0, tblView.frame.size.width, widgetHeight < MIN_WIDGET_HEIGHT ? MIN_WIDGET_HEIGHT : widgetHeight);
}
static void _logos_method$_ungrouped$PSUIPrefsListController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$_ungrouped$PSUIPrefsListController$viewDidLoad(self, _cmd);
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

static void _logos_method$_ungrouped$PSUIPrefsListController$traitCollectionDidChange$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITraitCollection * previousTraitCollection) {
	_logos_orig$_ungrouped$PSUIPrefsListController$traitCollectionDidChange$(self, _cmd, previousTraitCollection);
	[self.widgetContainerView setWidgetBackgrounds];
}

static void _logos_method$_ungrouped$PSUIPrefsListController$pushStoragePrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	

	[[_logos_static_class_lookup$PSURLManager() sharedManager] processURL:[NSURL URLWithString:@"prefs:root=General&path=STORAGE_MGMT%23OFFLOAD"] animated: YES fromSearch:NO withCompletion:nil];
}

static void _logos_method$_ungrouped$PSUIPrefsListController$pushBatteryPrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	[[_logos_static_class_lookup$PSURLManager() sharedManager] processURL:[NSURL URLWithString:@"prefs:root=BATTERY_USAGE"] animated: YES fromSearch:NO withCompletion:nil];
}

static void _logos_method$_ungrouped$PSUIPrefsListController$pushWifiPrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	[[_logos_static_class_lookup$PSURLManager() sharedManager] processURL:[NSURL URLWithString:@"prefs:root=WIFI"] animated: YES fromSearch:NO withCompletion:nil];
}

static void _logos_method$_ungrouped$PSUIPrefsListController$pushCellularPrefsPage(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	[[_logos_static_class_lookup$PSURLManager() sharedManager] processURL:[NSURL URLWithString:@"prefs:root=MOBILE_DATA_SETTINGS_ID"] animated: YES fromSearch:NO withCompletion:nil];
}



static __attribute__((constructor)) void _logosLocalCtor_6d35e6a1(int __unused argc, char __unused **argv, char __unused **envp) {
	loadPrefs();

	if (enabled)
		{Class _logos_class$_ungrouped$PSUIPrefsListController = objc_getClass("PSUIPrefsListController"); MSHookMessageEx(_logos_class$_ungrouped$PSUIPrefsListController, @selector(viewWillAppear:), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$viewWillAppear$, (IMP*)&_logos_orig$_ungrouped$PSUIPrefsListController$viewWillAppear$);MSHookMessageEx(_logos_class$_ungrouped$PSUIPrefsListController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$PSUIPrefsListController$viewDidLoad);MSHookMessageEx(_logos_class$_ungrouped$PSUIPrefsListController, @selector(traitCollectionDidChange:), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$traitCollectionDidChange$, (IMP*)&_logos_orig$_ungrouped$PSUIPrefsListController$traitCollectionDidChange$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$PSUIPrefsListController, @selector(pushStoragePrefsPage), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$pushStoragePrefsPage, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$PSUIPrefsListController, @selector(pushBatteryPrefsPage), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$pushBatteryPrefsPage, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$PSUIPrefsListController, @selector(pushWifiPrefsPage), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$pushWifiPrefsPage, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$PSUIPrefsListController, @selector(pushCellularPrefsPage), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$pushCellularPrefsPage, _typeEncoding); }{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(SWWidgetContainerView *)); class_addMethod(_logos_class$_ungrouped$PSUIPrefsListController, @selector(widgetContainerView), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$widgetContainerView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(SWWidgetContainerView *)); class_addMethod(_logos_class$_ungrouped$PSUIPrefsListController, @selector(setWidgetContainerView:), (IMP)&_logos_method$_ungrouped$PSUIPrefsListController$setWidgetContainerView, _typeEncoding); } }
}
