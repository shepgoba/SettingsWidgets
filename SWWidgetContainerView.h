#import "SWBatteryWidgetView.h"
#import "SWStorageWidgetView.h"
#import "SWWifiWidgetView.h"
#import "SWCellularWidgetView.h"
#import "SWWidgetView.h"
typedef NS_ENUM(NSUInteger, SWWidgetType) {
	SWWidgetTypeBattery,
	SWWidgetTypeStorage,
	SWWidgetTypeWifi,
	SWWidgetTypeCellular,
	SWWidgetTypeNone
};

@interface SWWidgetContainerView : UIView {
	SWWidgetView *_widgetView1;
	SWWidgetView *_widgetView2;
	BOOL _transparentWidgetBackgrounds;
}
-(void)setupWidgetsWithType1:(SWWidgetType)widgetType1 type2:(SWWidgetType)widgetType2 transparentBackground:(BOOL)transparent widgetInset:(int)inset cornerRadius:(int)cornerRadius;
-(void)setWidgetBackgrounds;
-(void)loadWidgetData;
@end