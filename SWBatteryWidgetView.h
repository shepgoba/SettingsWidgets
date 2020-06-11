#import "SWWidgetView.h"

@interface SWBatteryWidgetView : SWWidgetView
@property (nonatomic, assign) BOOL useBatteryHealth;
@property (nonatomic, strong) NSString *maximumCapacityPercent;
@property (nonatomic, strong) UILabel *healthLabel;
@end