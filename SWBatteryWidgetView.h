#import "SWWidgetView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SWBatteryWidgetView : SWWidgetView
@property (nonatomic, assign) BOOL useBatteryHealth;
@property (nonatomic, strong) NSString *maximumCapacityPercent;
@property (nonatomic, strong) UILabel *healthLabel;
@end