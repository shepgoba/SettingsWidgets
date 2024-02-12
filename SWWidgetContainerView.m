#import "SWWidgetContainerView.h"
#import <objc/runtime.h>
#import "CoreTelephonyClient.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <stdint.h>

@interface UIColor (ios13)
+(id)systemBackgroundColor ;
+(id)secondarySystemBackgroundColor ;
+(id)tableCellGroupedBackgroundColor ;
@end

@interface CTDataUsage : NSObject
@property (assign,nonatomic) unsigned long long cellularHome;                 //@synthesize cellularHome=_cellularHome - In the implementation block
@property (assign,nonatomic) unsigned long long cellularRoaming;              //@synthesize cellularRoaming=_cellularRoaming - In the implementation block
@property (assign,nonatomic) unsigned long long wifi;                         //@synthesize wifi=_wifi - In the implementation block
-(id)safeValueForKey:(NSString *)key;
@end

@interface CTDeviceDataUsage : NSObject
- (CTDataUsage *)totalDataUsageForPeriod:(unsigned long long)arg1;
- (CTDataUsage *)totalDataUsedForPeriod:(unsigned long long)arg1;

@end

@class CoreTelephonyClient;
@interface PSUICoreTelephonyDataCache : NSObject
+(instancetype)sharedInstance;
@property (nonatomic,retain) CoreTelephonyClient *client;
@end


@interface STStorageSpace : NSObject
-(uint64_t)freeBytes;
-(uint64_t)usedBytes;
@end

@interface CALayer (Undocumented)
@property (assign) BOOL continuousCorners;
@end
@interface STStorageDiskMonitor : NSObject
+(id)sharedMonitor;
-(void)updateDiskSpace;
-(uint64_t)deviceSize;
-(uint64_t)lastFree;
-(STStorageSpace *)storageSpace;
@end

@interface BatteryHealthUIController
-(NSString *)getChargeCapacityRemaining;
-(void)updateData;
@end

static NSString *getIPAddress() {
    NSString *address = @"error";
	BOOL hasFound = NO;

    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if (!strcmp(temp_addr->ifa_name, "en0")) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					hasFound = YES;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
	if (!hasFound) {
		address = @"Wi-Fi Not Connected";
	}
    // Free memory
    freeifaddrs(interfaces);
    return address;
} 
/*
static NSString *getIPAddress() {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
	bool didFindCellular, didFindWifi;

	didFindCellular = false;
	didFindWifi = false;
	// returns 0 on success
    int ifaddresses = getifaddrs(&interfaces);

    if (ifaddresses == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET || temp_addr->ifa_addr->sa_family == AF_INET6) {
                if (!strcmp(temp_addr->ifa_name, "en0")) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					didFindWifi = true;
                } else if (!strcmp(temp_addr->ifa_name, "pdp_ip0")) {
					//address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					didFindCellular = true;
				}
            }
            temp_addr = temp_addr->ifa_next;
        }
    }

    // Free memory

}*/


@implementation SWWidgetContainerView
-(CGSize)intrinsicContentSize {
	return CGSizeMake(0, 120);
}
-(void)setupWidgetsWithType1:(SWWidgetType)widgetType1 type2:(SWWidgetType)widgetType2 transparentBackground:(BOOL)transparent widgetInset:(int)inset cornerRadius:(int)cornerRadius {
	//widgetType1 = SWWidgetTypeNone;
	_widgetType1 = widgetType1;
	_widgetType2 = widgetType2;

	_transparentWidgetBackgrounds = transparent;
	Class _widgetView1Class;
	Class _widgetView2Class;
	
	int maxWidgetCount = 5;
	const Class classList[] = {[SWBatteryWidgetView class], [SWStorageWidgetView class], [SWWifiWidgetView class], [SWCellularWidgetView class], [SWUtilityWidgetView class]};
	
	if (widgetType1 != SWWidgetTypeNone) {
		if (widgetType1 < maxWidgetCount) {
			_widgetView1Class = classList[widgetType1];
			//_widgetView1Page = pageList[widgetType1];
		}
	}
	if (widgetType2 != SWWidgetTypeNone) {
		if (widgetType2 < maxWidgetCount) {
			_widgetView2Class = classList[widgetType2];
			//_widgetView2Page = pageList[widgetType2];
		}
	}

	if (!_widgetView1Class)
		_widgetView1Class = [UIView class];
	if (!_widgetView2Class)
		_widgetView2Class = [UIView class];

	if (widgetType1 != SWWidgetTypeNone) {
		_widgetView1 = [[_widgetView1Class alloc] init];
		_widgetView1.layer.cornerRadius = cornerRadius;
		if (@available(iOS 13.0, *)) {
			_widgetView1.layer.cornerCurve = kCACornerCurveContinuous;
		} else {
			_widgetView1.layer.continuousCorners = YES;
		}
		_widgetView1.translatesAutoresizingMaskIntoConstraints = NO;
		UITapGestureRecognizer *widget1TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_widgetView1 action:@selector(openPrefsURL)];
		[_widgetView1 addGestureRecognizer:widget1TapGestureRecognizer];
		if ([_widgetView1 respondsToSelector:@selector(setup)])
			[_widgetView1 setup];

		[self addSubview: _widgetView1];
	}

	if (widgetType2 != SWWidgetTypeNone) {
		_widgetView2 = [[_widgetView2Class alloc] init];
		_widgetView2.layer.cornerRadius = cornerRadius;
		if (@available(iOS 13.0, *)) {
			_widgetView2.layer.cornerCurve = kCACornerCurveContinuous;
		} else {
			_widgetView2.layer.continuousCorners = YES;
		}
		_widgetView2.translatesAutoresizingMaskIntoConstraints = NO;
		UITapGestureRecognizer *widget2TapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_widgetView2 action:@selector(openPrefsURL)];
		[_widgetView2 addGestureRecognizer:widget2TapGestureRecognizer];
		if ([_widgetView2 respondsToSelector:@selector(setup)])
			[_widgetView2 setup];

		[self addSubview: _widgetView2];
	}

	/*if (widgetType1 != SWWidgetTypeNone) {
		[_widgetView1.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant:inset].active = YES;
		[_widgetView1.trailingAnchor constraintEqualToAnchor: self.centerXAnchor constant:-7.5].active = YES;
		[_widgetView1.topAnchor constraintEqualToAnchor: self.topAnchor constant:5].active = YES;
		[_widgetView1.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-15].active = YES;
	} else*/
	if (widgetType1 == SWWidgetTypeNone || widgetType2 == SWWidgetTypeNone) {
		if (widgetType1 == SWWidgetTypeNone) {
			[_widgetView2.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant:inset].active = YES;
			[_widgetView2.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant:-inset].active = YES;
			[_widgetView2.topAnchor constraintEqualToAnchor: self.topAnchor constant:5].active = YES;
			[_widgetView2.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-15].active = YES;

			[_widgetView2 updateForBigWidgetView];
		} else {
			[_widgetView1.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant:inset].active = YES;
			[_widgetView1.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant:-inset].active = YES;
			[_widgetView1.topAnchor constraintEqualToAnchor: self.topAnchor constant:5].active = YES;
			[_widgetView1.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-15].active = YES;

			[_widgetView1 updateForBigWidgetView];
		}
	} else {
		[_widgetView1.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant:inset].active = YES;
		[_widgetView1.trailingAnchor constraintEqualToAnchor: self.centerXAnchor constant:-7.5].active = YES;
		[_widgetView1.topAnchor constraintEqualToAnchor: self.topAnchor constant:5].active = YES;
		[_widgetView1.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-15].active = YES;

		[_widgetView2.leadingAnchor constraintEqualToAnchor: self.centerXAnchor constant:7.5].active = YES;
		[_widgetView2.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant:-inset].active = YES;
		[_widgetView2.topAnchor constraintEqualToAnchor: self.topAnchor constant:5].active = YES;
		[_widgetView2.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-15].active = YES;
	}
	
	/*if (widgetType1 == widgetType2 != SWWidgetTypeNone) {
		[_widgetView2.leadingAnchor constraintEqualToAnchor: self.centerXAnchor constant:7.5].active = YES;
		[_widgetView2.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant:-inset].active = YES;
		[_widgetView2.topAnchor constraintEqualToAnchor: self.topAnchor constant:5].active = YES;
		[_widgetView2.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-15].active = YES;
	}*/
	[self loadWidgetData];
}
-(BOOL)shouldLoadBatteryData {
	if ([_widgetView1 isKindOfClass:[SWBatteryWidgetView class]] || [_widgetView2 isKindOfClass:[SWBatteryWidgetView class]]) {
		return YES;
	}
	return NO;
}
-(BOOL)shouldLoadStorageData {
	if ([_widgetView1 isKindOfClass:[SWStorageWidgetView class]] || [_widgetView2 isKindOfClass:[SWStorageWidgetView class]]) {
		return YES;
	}
	return NO;
}
-(BOOL)shouldLoadWifiData {
	if ([_widgetView1 isKindOfClass:[SWWifiWidgetView class]] || [_widgetView2 isKindOfClass:[SWWifiWidgetView class]]) {
		return YES;
	}
	return NO;
}
-(BOOL)shouldLoadCellularData {
	if ([_widgetView1 isKindOfClass:[SWCellularWidgetView class]] || [_widgetView2 isKindOfClass:[SWCellularWidgetView class]]) {
		return YES;
	}
	return NO;
}
-(void)loadWidgetData {
	if ([self shouldLoadBatteryData]) {
		static dispatch_once_t batteryDataToken;
    	static NSString *g_maximumCapacityPercent;
		dispatch_once(&batteryDataToken, ^{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSBundle *storageSettingsBundle = [NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/BatteryUsageUI.bundle"];
				[storageSettingsBundle load];
				Class healthClass = objc_getClass("BatteryHealthUIController");
				if (healthClass) {
					BatteryHealthUIController *instance = [healthClass new];
					[instance updateData];
					g_maximumCapacityPercent = [instance getChargeCapacityRemaining];
				}
				__block BOOL useBatteryHealth = NO;
				if (![g_maximumCapacityPercent isEqual: @"—"])
					useBatteryHealth = YES;

				dispatch_async(dispatch_get_main_queue(), ^{
					//_healthLabel.text = _useBatteryHealth ? [NSString stringWithFormat:@"Max Capacity: %@", _maximumCapacityPercent] : [NSString stringWithFormat:@"Battery Level: %.0f%%", [UIDevice currentDevice].batteryLevel*100];
					NSDictionary *data = @{@"useBatteryHealth": @(useBatteryHealth), @"maximumCapacityPercent": g_maximumCapacityPercent};
					if (_widgetType1 == SWWidgetTypeBattery)
						([_widgetView1 updateForData:data]);
					if (_widgetType2 == SWWidgetTypeBattery)
						[_widgetView2 updateForData:data];
				});
			});
		});
	}
	if ([self shouldLoadStorageData]) {		
		static dispatch_once_t dataToken;
		static uint64_t g_totalDiskSpace;
		static uint64_t g_usedDiskSpace;

		dispatch_once(&dataToken, ^{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSBundle *storageSettingsBundle = [NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/StorageSettings.bundle"];
				[storageSettingsBundle load];
				STStorageDiskMonitor *monitor = [objc_getClass("STStorageDiskMonitor") new];

				uint64_t totalDiskSpace = monitor.deviceSize;
				uint64_t usedDiskSpace;
				if (monitor && [monitor respondsToSelector:@selector(updateDiskSpace)])
					[monitor updateDiskSpace];

				// iOS 14
				if ([monitor respondsToSelector:@selector(storageSpace)]) {
					usedDiskSpace = monitor.storageSpace.usedBytes;
				} else {
					usedDiskSpace = totalDiskSpace - monitor.lastFree;
				}

				g_totalDiskSpace = totalDiskSpace;
				g_usedDiskSpace = usedDiskSpace;
				dispatch_async(dispatch_get_main_queue(), ^{
					NSDictionary *data = @{@"usedDiskSpace": @(g_usedDiskSpace), @"totalDiskSpace": @(g_totalDiskSpace)};
					if (_widgetType1 == SWWidgetTypeStorage)
						[_widgetView1 updateForData:data];
					if (_widgetType2 == SWWidgetTypeStorage)
						[_widgetView2 updateForData:data];
				});
			});
		});
	}
	if ([self shouldLoadWifiData]) {
		NSString *result = getIPAddress();

		NSDictionary *data = @{@"ipAddress": result};
		if (_widgetType1 == SWWidgetTypeWifi)
			[_widgetView1 updateForData:data];
		if (_widgetType2 == SWWidgetTypeWifi)
			[_widgetView2 updateForData:data];
		//[NSNotificationCenter.defaultCenter postNotificationName:@"SWWiFiDataProcessedNotification" object:nil userInfo:data];
	}
	if ([self shouldLoadCellularData]) {
		Class cls = objc_getClass("PSUICoreTelephonyDataCache");
		BOOL failed = NO;
		if (!cls)
			failed = YES;
		PSUICoreTelephonyDataCache *dataCache = [cls sharedInstance];
		if (dataCache) {
			CoreTelephonyClient *client = dataCache.client;
			if (client) {
				[client dataUsageForLastPeriods:2 completion:^(CTDeviceDataUsage *dataUsage, NSError *arg2) {
					BOOL block_failed = NO;
					if (dataUsage) {
						CTDataUsage *usage = nil;
						if ([dataUsage respondsToSelector:@selector(totalDataUsageForPeriod:)])
						 	usage = [dataUsage totalDataUsageForPeriod:0];
						else if ([dataUsage respondsToSelector:@selector(totalDataUsedForPeriod:)])
							usage = [dataUsage totalDataUsedForPeriod:0];
						else
							block_failed = YES;
						if (usage) {
							unsigned long long actualDataUsageBytes = (unsigned long long)[usage safeValueForKey:@"_cellularHome"] + (unsigned long long)[usage safeValueForKey:@"_cellularRoaming"];
							//NSLog(@"jew %llu", [usage cellularHome]);
							dispatch_async(dispatch_get_main_queue(), ^{
								NSDictionary *data = @{@"cellularUsage": @(actualDataUsageBytes)};
								if (_widgetType1 == SWWidgetTypeCellular)
									[_widgetView1 updateForData:data];
								if (_widgetType2 == SWWidgetTypeCellular)
									[_widgetView2 updateForData:data];
							});
						} else {
							block_failed = YES;
						}
					} else {
						block_failed = YES;
					}

					if (block_failed) {
						dispatch_async(dispatch_get_main_queue(), ^{
							NSDictionary *data = @{@"cellularUsage": @0};
							if (_widgetType1 == SWWidgetTypeCellular)
								[_widgetView1 updateForData:data];
							if (_widgetType2 == SWWidgetTypeCellular)
								[_widgetView2 updateForData:data];
						});
					}
				}];
			} else {
				failed = YES;
			}
		} else {
			failed = YES;
		}

		if (failed) {
			NSDictionary *data = @{@"cellularUsage": @0};
			if (_widgetType1 == SWWidgetTypeCellular)
				[_widgetView1 updateForData:data];
			if (_widgetType2 == SWWidgetTypeCellular)
				[_widgetView2 updateForData:data];
		}
	}
}
-(void)doNothing {

}
-(void)setWidgetBackgrounds {
	if (_transparentWidgetBackgrounds) {
		_widgetView1.backgroundColor = UIColor.clearColor;
		_widgetView2.backgroundColor = UIColor.clearColor;
		return;
	}
	if (@available(iOS 13, *)) {
		if ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark) {
			_widgetView1.backgroundColor = UIColor.tableCellGroupedBackgroundColor;
			_widgetView2.backgroundColor = UIColor.tableCellGroupedBackgroundColor;
			return;
		}
	}
	_widgetView1.backgroundColor = [UIColor whiteColor];
	_widgetView2.backgroundColor = [UIColor whiteColor];
}

@end