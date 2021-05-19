#import "SWCellularWidgetView.h"
#import <objc/runtime.h>
#import <math.h>
#import "utils.h"


@interface PSUICellularPlanManagerCache : NSObject
+(id)sharedInstance;
-(NSArray *)planItems;
-(BOOL)isAirplaneModeEnabled;
@end

static inline float BtoGB(unsigned long long bytes) {
	return (float)bytes / 1024 / 1024 / 1024;
}

@implementation SWCellularWidgetView
-(NSString *)iconImage {
	return @"cellularicon";
}
-(NSString *)widgetHeaderLocalizationString {
	return @"CELLULAR_WIDGET_HEADER";
}
-(NSString *)prefsURL {
	return @"prefs:root=MOBILE_DATA_SETTINGS_ID";
}
-(void)setup {
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateForDataReceived:) name:@"SWCellularDataProcessedNotification" object:nil];
	[super setup];
}
-(void)additionalSetup {

	_loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleMedium];
	_loadingView.translatesAutoresizingMaskIntoConstraints = NO;

	[self  addSubview: _loadingView];
	[_loadingView.leadingAnchor constraintEqualToAnchor: self.centerXAnchor constant: -10].active = YES;
	[_loadingView.trailingAnchor constraintEqualToAnchor: self.centerXAnchor constant: 10].active = YES;
	[_loadingView.topAnchor constraintEqualToAnchor: self.bottomAnchor constant: -35].active = YES;
	[_loadingView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -15].active = YES;

	[_loadingView startAnimating];

    _dataUsageLabel = [[UILabel alloc] init];
	//_useBatteryHealth ? [NSString stringWithFormat:@"Max Capacity: %@", _maximumCapacityPercent] : [NSString stringWithFormat:@"Battery Level: %.0f%%", [UIDevice currentDevice].batteryLevel*100];
	_dataUsageLabel.font = [UIFont boldSystemFontOfSize:13];
    _dataUsageLabel.textAlignment = NSTextAlignmentCenter;
	_dataUsageLabel.adjustsFontSizeToFitWidth = YES;
	_dataUsageLabel.minimumScaleFactor = 0.6;
	_dataUsageLabel.numberOfLines = 1;
	_dataUsageLabel.hidden = YES;
	_dataUsageLabel.translatesAutoresizingMaskIntoConstraints = NO;

	[self addSubview: _dataUsageLabel];

	[_dataUsageLabel.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -15].active = YES;
	[_dataUsageLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10].active = YES;
	[_dataUsageLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -10].active = YES;
}

-(void)updateForData:(NSDictionary *)receievedData {
	[_loadingView removeFromSuperview];
	_dataUsageLabel.hidden = NO;

	unsigned long long cellularDataUsage = [receievedData[@"cellularUsage"] unsignedLongLongValue];
	_dataUsageLabel.text = [NSString stringWithFormat:@"%@: %.01fGB", localizedStringForKey(@"DATA_USAGE"), round(BtoGB(cellularDataUsage) * 10.0) / 10.0];
}
@end