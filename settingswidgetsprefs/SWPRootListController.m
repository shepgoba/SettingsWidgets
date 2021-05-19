#include "SWPRootListController.h"
#include <spawn.h>

@interface PSSpecifier
-(id)propertyForKey:(NSString *)key;
@end

@interface NSUserDefaults (bonus)
- (id)objectForKey:(id)arg1 inDomain:(id)arg2;
@end

@implementation SWPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	NSArray *chosenIDs = @[@"widgetOption2"];
	self.savedSpecifiers = (!self.savedSpecifiers) ? [[NSMutableDictionary alloc] init] : self.savedSpecifiers;
	for (PSSpecifier *specifier in _specifiers) {
		if ([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
			[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
		}
	}
	return _specifiers;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(applySettings)];
    self.navigationItem.rightBarButtonItem = applyButton;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	/*PSSpecifier *widgetSelect1 = [self specifierForID:@"widgetOption1"];
	PSSpecifier *widgetSelect2 = [self specifierForID:@"widgetOption2"];

	UISegmentedControl *widgetControl1 = [widgetSelect1 propertyForKey:@"control"];
	UISegmentedControl *widgetControl2 = [widgetSelect2 propertyForKey:@"control"];

	[widgetControl2 setEnabled:NO forSegmentAtIndex: 1];
	[widgetControl1 setEnabled:NO forSegmentAtIndex: 1];*/
	//NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.shepgoba.settingswidgetsprefs.plist"];
   	NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"widget2Enabled" inDomain:@"com.shepgoba.settingswidgetsprefs"];
	if (![value boolValue]) {
     	[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"widgetOption2"]] animated:YES];
   	}
	
	//NSNumber *value1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"widgetType1" inDomain:@"com.shepgoba.settingswidgetsprefs"];
	//UISegmentedControl *widgetControl2 = [[self specifierForID:@"widgetType2"] propertyForKey:@"control"];
	//[widgetControl2 setEnabled:NO forSegmentAtIndex: [value1 integerValue]];
}
-(void)reloadSpecifiers {
	[super reloadSpecifiers];
	NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"widget2Enabled" inDomain:@"com.shepgoba.settingswidgetsprefs"];
	if (![value boolValue]) {
     	[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"widgetOption2"]] animated:YES];
   	}
	
}

-(void)applySettings {
	pid_t pid;
	const char *argv[] = {"killall", "Preferences", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)argv, NULL);
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[super setPreferenceValue:value specifier:specifier];

	PSSpecifier *widget2EnabledSpecifier = [self specifierForID:@"widget2EnabledSwitch"];
	if (specifier == widget2EnabledSpecifier) {
		UISwitch *widget2EnabledSwitch = [widget2EnabledSpecifier propertyForKey:@"control"];
		if (widget2EnabledSwitch.isOn) {
			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"widgetOption2"]] afterSpecifierID:@"widget2EnabledSwitch" animated:YES];
		} else {
			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"widgetOption2"]] animated:YES];
		}
	}

}

-(void)openTwitter{
	NSURL *twitter = [NSURL URLWithString:@"https://twitter.com/shepgoba"];
	[[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];
}
-(void)openIconTwitter{
	NSURL *twitter = [NSURL URLWithString:@"https://twitter.com/JannikCrack"];
	[[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];
}
@end
