#import "SWStorageWidgetView.h"

@implementation SWStorageWidgetView
-(NSString *)iconImage {
    return @"storageicon";
}
-(NSString *)widgetHeaderLocalizationString {
    return @"STORAGE_WIDGET_HEADER";
}

-(SWDiskUsageView *)diskUsageView {
    return _diskUsageView;
}
-(void)setup {
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateForDataReceived:) name:@"SWStorageDataProcessedNotification" object:nil];
	[super setup];
}
-(void)additionalSetup {
    _diskUsageView = [[SWDiskUsageView alloc] init];
    _diskUsageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview: _diskUsageView];   

    [_diskUsageView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-10].active = YES;
    [_diskUsageView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor].active = YES;
    [_diskUsageView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor].active = YES;
    [_diskUsageView setup];
}
-(void)updateForDataReceived:(NSNotification *)notification {
	NSDictionary *receievedData = [notification userInfo];
	NSUInteger usedDiskSpace = [receievedData[@"usedDiskSpace"] integerValue];
    NSUInteger totalDiskSpace = [receievedData[@"totalDiskSpace"] integerValue];
    
    [_diskUsageView updateDiskBarForUsedDiskSpace:usedDiskSpace totalSpace:totalDiskSpace];
}

@end