@interface SWWidgetView : UIView
@property (nonatomic, strong) UILabel *widgetHeaderLabel;
@property (nonatomic, strong) UIImageView *widgetIconImageView;
@property (nonatomic, strong) NSString *iconImage;
@property (nonatomic, strong) NSString *widgetHeaderLocalizationString;
-(void)setup;
-(void)additionalSetup;
-(void)updateForBigWidgetView;
@end
