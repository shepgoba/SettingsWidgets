#line 1 "Tweak.xm"
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
	NSDictionary *settings = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.shepgoba.settingswidgetsprefs"];


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

@interface IXAppInstallCoordinator : NSObject
+(void)uninstallAppWithBundleID:(id)arg1 requestUserConfirmation:(BOOL)arg2 waitForDeletion:(BOOL)arg3 completion:(id)arg4 ;
@end


extern "C"
CFArrayRef IOPSCopyPowerSourcesByType(int type);


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

@class PSUIPrefsListController; 


#line 97 "Tweak.xm"
static void (*_logos_orig$Tweak$PSUIPrefsListController$viewWillAppear$)(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$Tweak$PSUIPrefsListController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$Tweak$PSUIPrefsListController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void _logos_method$Tweak$PSUIPrefsListController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$Tweak$PSUIPrefsListController$traitCollectionDidChange$)(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UITraitCollection *); static void _logos_method$Tweak$PSUIPrefsListController$traitCollectionDidChange$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UITraitCollection *); 

__attribute__((used)) static SWWidgetContainerView * _logos_property$Tweak$PSUIPrefsListController$widgetContainerView(PSUIPrefsListController * __unused self, SEL __unused _cmd) { return (SWWidgetContainerView *)objc_getAssociatedObject(self, (void *)_logos_property$Tweak$PSUIPrefsListController$widgetContainerView); };
__attribute__((used)) static void _logos_property$Tweak$PSUIPrefsListController$setWidgetContainerView(PSUIPrefsListController * __unused self, SEL __unused _cmd, SWWidgetContainerView * rawValue) { objc_setAssociatedObject(self, (void *)_logos_property$Tweak$PSUIPrefsListController$widgetContainerView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
static void _logos_method$Tweak$PSUIPrefsListController$viewWillAppear$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
	_logos_orig$Tweak$PSUIPrefsListController$viewWillAppear$(self, _cmd, arg1);
	UITableView *tblView = [self valueForKey:@"_table"];
	self.widgetContainerView.frame = CGRectMake(0, 0, tblView.frame.size.width, widgetHeight < MIN_WIDGET_HEIGHT ? MIN_WIDGET_HEIGHT : widgetHeight);
}
static void _logos_method$Tweak$PSUIPrefsListController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$Tweak$PSUIPrefsListController$viewDidLoad(self, _cmd);

	int healthPercent;

	NSArray *sources = (__bridge NSArray *)IOPSCopyPowerSourcesByType(1);
	NSDictionary *batteryDict = sources[0];
	if (sources && sources.count && batteryDict[@"Maximum Capacity Percent"]) {
		healthPercent = [batteryDict[@"Maximum Capacity Percent"] intValue];
	} else {
		healthPercent = -1;
	}

	double constraintedHealthPercent = fmax(fmin(healthPercent / 100.0, 1.0), 0.0) * 100;

	int finalPercent = (int)constraintedHealthPercent;
	NSLog(@"correctedHealthPercent: %i", finalPercent);

	UITableView *tblView = [self valueForKey:@"_table"];

	self.widgetContainerView = [[SWWidgetContainerView alloc] init];
	self.widgetContainerView.backgroundColor = UIColor.clearColor;

	tblView.tableHeaderView = self.widgetContainerView;

	if (!widget2Enabled)
		widgetType2 = SWWidgetTypeNone;

	[self.widgetContainerView setupWidgetsWithType1:widgetType1 type2:widgetType2 transparentBackground:transparentMode widgetInset:widgetInset cornerRadius:widgetCornerRadius];
	[self.widgetContainerView setWidgetBackgrounds];

}

static void _logos_method$Tweak$PSUIPrefsListController$traitCollectionDidChange$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UITraitCollection * previousTraitCollection) {
	_logos_orig$Tweak$PSUIPrefsListController$traitCollectionDidChange$(self, _cmd, previousTraitCollection);
	[self.widgetContainerView setWidgetBackgrounds];
}




static __attribute__((constructor)) void _logosLocalCtor_4de51287(int __unused argc, char __unused **argv, char __unused **envp) {
	loadPrefs();
	if (enabled)
		{Class _logos_class$Tweak$PSUIPrefsListController = objc_getClass("PSUIPrefsListController"); { objc_property_attribute_t _attributes[16]; unsigned int attrc = 0; _attributes[attrc++] = (objc_property_attribute_t) { "T", "@\"SWWidgetContainerView\"" }; _attributes[attrc++] = (objc_property_attribute_t) { "&", "" }; _attributes[attrc++] = (objc_property_attribute_t) { "N", "" }; class_addProperty(_logos_class$Tweak$PSUIPrefsListController, "widgetContainerView", _attributes, attrc); char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(SWWidgetContainerView *)); class_addMethod(_logos_class$Tweak$PSUIPrefsListController, @selector(widgetContainerView), (IMP)&_logos_property$Tweak$PSUIPrefsListController$widgetContainerView, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(SWWidgetContainerView *)); class_addMethod(_logos_class$Tweak$PSUIPrefsListController, @selector(setWidgetContainerView:), (IMP)&_logos_property$Tweak$PSUIPrefsListController$setWidgetContainerView, _typeEncoding); } { MSHookMessageEx(_logos_class$Tweak$PSUIPrefsListController, @selector(viewWillAppear:), (IMP)&_logos_method$Tweak$PSUIPrefsListController$viewWillAppear$, (IMP*)&_logos_orig$Tweak$PSUIPrefsListController$viewWillAppear$);}{ MSHookMessageEx(_logos_class$Tweak$PSUIPrefsListController, @selector(viewDidLoad), (IMP)&_logos_method$Tweak$PSUIPrefsListController$viewDidLoad, (IMP*)&_logos_orig$Tweak$PSUIPrefsListController$viewDidLoad);}{ MSHookMessageEx(_logos_class$Tweak$PSUIPrefsListController, @selector(traitCollectionDidChange:), (IMP)&_logos_method$Tweak$PSUIPrefsListController$traitCollectionDidChange$, (IMP*)&_logos_orig$Tweak$PSUIPrefsListController$traitCollectionDidChange$);}}
}
