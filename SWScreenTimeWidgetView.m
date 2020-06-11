#import "SWScreenTimeWidgetView.h"

@implementation SWScreenTimeWidgetView

static NSString *getScreenTimeUsage() {
	NSString *default = "0h 0m";
} 

@implementation SWWifiWidgetView
-(NSString *)iconImage {
    return @"screentime";
}
-(NSString *)widgetHeaderLocalizationString {
    return @"Screen Time";
}
-(void)additionalSetup {
	_ipAddressLabel = [[UILabel alloc] init];
	_ipAddressLabel.text = getScreenTimeUsage();
	_ipAddressLabel.numberOfLines = 2;
	_ipAddressLabel.font = [UIFont boldSystemFontOfSize:13];
    _ipAddressLabel.textAlignment = NSTextAlignmentCenter;
	_ipAddressLabel.translatesAutoresizingMaskIntoConstraints = NO;

	[self addSubview: _ipAddressLabel];

	[_ipAddressLabel.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -15].active = YES;
	[_ipAddressLabel.leadingAnchor constraintEqualToConstant: 10].active = YES;
	[_ipAddressLabel.trailingAnchor constraintEqualToConstant: -10].active = YES;
}
@end