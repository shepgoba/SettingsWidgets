#import "utils.h"
#import "SWWifiWidgetView.h"

@implementation SWWifiWidgetView
-(NSString *)iconImage {
    return @"wifiicon";
}
-(NSString *)widgetHeaderLocalizationString {
    return @"WIFI_WIDGET_HEADER";
}
-(NSString *)prefsURL {
	return @"prefs:root=WIFI";
}
-(void)additionalSetup {

	_ipAddressLabel = [[UILabel alloc] init];
	_ipAddressLabel.text = [NSString stringWithFormat:@"%@: 000.000.000.000", localizedStringForKey(@"LOCAL_IP_ADDRESS")];
	_ipAddressLabel.numberOfLines = 2;
	_ipAddressLabel.font = [UIFont boldSystemFontOfSize:13];
	_ipAddressLabel.textAlignment = NSTextAlignmentCenter;
	_ipAddressLabel.translatesAutoresizingMaskIntoConstraints = NO;

	[self addSubview: _ipAddressLabel];

	[_ipAddressLabel.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -15].active = YES;
	[_ipAddressLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10].active = YES;
	[_ipAddressLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -10].active = YES;
}
-(void)updateForData:(NSDictionary *)receievedData {
	NSString *ipAddressString = receievedData[@"ipAddress"];
	NSString *localizedIPAddressString = localizedStringForKey(@"LOCAL_IP_ADDRESS");
	
	_ipAddressLabel.text = [NSString stringWithFormat:@"%@:\n%@", localizedIPAddressString, ipAddressString];
}
@end