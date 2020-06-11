#import "SWWifiWidgetView.h"
#import "utils.h"

@implementation SWWifiWidgetView
-(NSString *)iconImage {
    return @"wifiicon";
}
-(NSString *)widgetHeaderLocalizationString {
    return @"WIFI_WIDGET_HEADER";
}
-(void)setup {
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateForDataReceived:) name:@"SWWiFiDataProcessedNotification" object:nil];
	[super setup];
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
-(void)updateForDataReceived:(NSNotification *)notification {
		NSBundle *tweakBundle = [[NSBundle alloc] initWithPath:@"/Library/Application Support/SettingsWidgets"];

	NSDictionary *receievedData = [notification userInfo];
	NSString *ipAddressString = receievedData[@"ipAddress"];

	_ipAddressLabel.text = [NSString stringWithFormat:@"%@:\n%@", [tweakBundle localizedStringForKey:@"LOCAL_IP_ADDRESS" value:@"" table:nil], ipAddressString];
}
@end