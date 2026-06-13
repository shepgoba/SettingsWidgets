#import "SWBatteryWidgetView.h"
#import "utils.h"
#import <objc/runtime.h>
extern void ADClientSetValueForScalarKey(char *key, long long val);


@implementation SWBatteryWidgetView
-(NSString *)iconImage {
	return @"batteryicon";
}
-(NSString *)widgetHeaderLocalizationString {
	return @"BATTERY_WIDGET_HEADER";
}
-(NSString *)prefsURL {
	return @"prefs:root=BATTERY_USAGE";
}

-(void)additionalSetup {
	UIDevice.currentDevice.batteryMonitoringEnabled = YES;
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateBatteryLevelText) name:@"UIDeviceBatteryLevelDidChangeNotification" object:nil];
	_useBatteryHealth = YES;
    _healthLabel = [[UILabel alloc] init];
	_healthLabel.text = _useBatteryHealth ? [NSString stringWithFormat:@"%@: 00%%", localizedStringForKey(@"BATTERY_MAX_CAPACITY")] : [NSString stringWithFormat:@"%@: %.0f%%", localizedStringForKey(@"BATTERY_LEVEL"), [UIDevice currentDevice].batteryLevel*100];
	_healthLabel.font = [UIFont boldSystemFontOfSize:13];
    _healthLabel.textAlignment = NSTextAlignmentCenter;
	_healthLabel.adjustsFontSizeToFitWidth = YES;
	_healthLabel.minimumScaleFactor = 0.6;
	_healthLabel.numberOfLines = 1;
	_healthLabel.translatesAutoresizingMaskIntoConstraints = NO;

	[self addSubview: _healthLabel];

	[_healthLabel.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -15].active = YES;
	[_healthLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10].active = YES;
	[_healthLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -10].active = YES;
    //});
}
-(void)updateBatteryLevelText {
	if (!_useBatteryHealth) {
		_healthLabel.text = [NSString stringWithFormat:@"Battery Level: %.0f%%", [UIDevice currentDevice].batteryLevel * 100];
	}
}
-(void)updateForData:(NSDictionary *)receievedData {
	NSString *maximumCapacityPercent = receievedData[@"maximumCapacityPercent"];
	BOOL useBatteryHealth = [receievedData[@"useBatteryHealth"] boolValue];
	_useBatteryHealth = useBatteryHealth;
	_healthLabel.text = useBatteryHealth ? [NSString stringWithFormat:@"%@: %@", localizedStringForKey(@"BATTERY_MAX_CAPACITY"), maximumCapacityPercent] : [NSString stringWithFormat:@"%@: %.0f%%", localizedStringForKey(@"BATTERY_LEVEL"), [UIDevice currentDevice].batteryLevel*100];
	//_healthLabel.text = _useBatteryHealth ? [NSString stringWithFormat:@"Max Capacity: %@", _maximumCapacityPercent] : [NSString stringWithFormat:@"Battery Level: %.0f%%", [UIDevice currentDevice].batteryLevel*100];
}

@end

/*

requires: com.apple.private.iokit.batterydata entitlement, probably no sandbox

extern "C"
CFArrayRef IOPSCopyPowerSourcesByType(int type);

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

*/