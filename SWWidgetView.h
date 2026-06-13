#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SWWidgetType) {
	SWWidgetTypeBattery,
	SWWidgetTypeStorage,
	SWWidgetTypeWifi,
	SWWidgetTypeCellular,
    SWWidgetTypeUtility,
	SWWidgetTypeNone
};

@interface SWWidgetView : UIView
@property (nonatomic, strong) UILabel *widgetHeaderLabel;
@property (nonatomic, strong) UIImageView *widgetIconImageView;
@property (nonatomic, strong) NSString *iconImage;
@property (nonatomic, strong) NSString *widgetHeaderLocalizationString;
@property (nonatomic, strong) NSString *prefsURL;
@property (nonatomic, assign) BOOL hasPrefsURL;
-(void)setup;
-(void)additionalSetup;
-(void)updateForBigWidgetView;
-(void)updateForData:(NSDictionary *)data;
@end
