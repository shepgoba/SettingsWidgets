#include "SWPRootListController.h"
#include <spawn.h>
#import <Preferences/PSSpecifier.h>
#import <rootless.h>

@interface NSUserDefaults (bonus)
- (id)objectForKey:(id)arg1 inDomain:(id)arg2;
@end

@implementation SWPRootListController

-(NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(applySettings)];
    self.navigationItem.rightBarButtonItem = applyButton;
}

-(void)applySettings {
	pid_t pid;
	const char *argv[] = {"killall", "Preferences", NULL};
	posix_spawn(&pid, ROOT_PATH("/usr/bin/killall"), NULL, NULL, (char * const *)argv, NULL);
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
