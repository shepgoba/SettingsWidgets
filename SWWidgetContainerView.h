#import "SWWidgetView.h"
#import "SWBatteryWidgetView.h"
#import "SWStorageWidgetView.h"
#import "SWWifiWidgetView.h"
#import "SWCellularWidgetView.h"
#import "SWUtilityWidgetView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SWWidgetContainerView : UIView {
	SWWidgetView *_widgetView1;
	SWWidgetView *_widgetView2;
	SWWidgetType _widgetType1;
	SWWidgetType _widgetType2;
	BOOL _transparentWidgetBackgrounds;
}
-(void)setupWidgetsWithType1:(SWWidgetType)widgetType1 type2:(SWWidgetType)widgetType2 transparentBackground:(BOOL)transparent widgetInset:(int)inset cornerRadius:(int)cornerRadius;
-(void)setWidgetBackgrounds;
-(void)loadWidgetData;
@end