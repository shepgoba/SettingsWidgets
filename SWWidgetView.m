#import "SWWidgetView.h"
#import <objc/runtime.h>
#import <rootless.h>

@interface PSURLManager : NSObject
+ (id)sharedManager;
- (void)processURL:(id)arg1 animated:(_Bool)arg2 fromSearch:(_Bool)arg3 withCompletion:(id)arg4;
@end

@implementation SWWidgetView
-(instancetype)init {
    if (self = [super init])  {
       	self.hasPrefsURL = YES;
    }
    return self;
}
-(void)setup {
	NSBundle *tweakBundle = [[NSBundle alloc] initWithPath:@ROOT_PATH("/Library/Application Support/SettingsWidgets")];
	NSString *imagePath = [tweakBundle pathForResource:self.iconImage ofType:@"png"];
	UIImage *storageIconImage = [UIImage imageWithContentsOfFile:imagePath];
	UIImage *storageIconImageScaled =  [UIImage imageWithCGImage:[storageIconImage CGImage] scale:(storageIconImage.scale * 3) orientation:(storageIconImage.imageOrientation)];

    _widgetIconImageView = [[UIImageView alloc] initWithImage:storageIconImageScaled];
	_widgetIconImageView.layer.masksToBounds = YES;
	_widgetIconImageView.layer.cornerRadius = 14.5;
    _widgetIconImageView.translatesAutoresizingMaskIntoConstraints = NO;

    _widgetHeaderLabel = [[UILabel alloc] init];
	_widgetHeaderLabel.text = [tweakBundle localizedStringForKey:self.widgetHeaderLocalizationString value:@"" table:nil];
	_widgetHeaderLabel.font = [UIFont boldSystemFontOfSize:15];
    _widgetHeaderLabel.textAlignment = NSTextAlignmentLeft;
    _widgetHeaderLabel.adjustsFontSizeToFitWidth = YES;
	_widgetHeaderLabel.minimumScaleFactor = 0.6;
	_widgetHeaderLabel.numberOfLines = 2;
    _widgetHeaderLabel.translatesAutoresizingMaskIntoConstraints = NO;

	[self addSubview: _widgetIconImageView];
	[self addSubview: _widgetHeaderLabel];

	[_widgetHeaderLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant:-7.5].active = YES;
	[_widgetHeaderLabel.leadingAnchor constraintEqualToAnchor: _widgetIconImageView.trailingAnchor constant:7.5].active = YES;
	[_widgetHeaderLabel.centerYAnchor constraintEqualToAnchor: _widgetIconImageView.centerYAnchor].active = YES;

	[_widgetIconImageView.topAnchor constraintEqualToAnchor: self.topAnchor constant: 12.5].active = YES;
	[_widgetIconImageView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 12.5].active = YES;
	[_widgetIconImageView.widthAnchor constraintEqualToConstant: storageIconImage.size.width].active = YES;
	[_widgetIconImageView.heightAnchor constraintEqualToConstant: storageIconImage.size.height].active = YES;

	[self additionalSetup];
}
-(void)openPrefsURL {
	if (self.hasPrefsURL) {
		static Class managerClass = nil;
		if (!managerClass)
			managerClass = objc_getClass("PSURLManager");
		[[managerClass sharedManager] processURL:[NSURL URLWithString:self.prefsURL] animated: YES fromSearch:NO withCompletion:nil];
	}
}
-(void)additionalSetup {
	// Do additonal setup here
}
-(void)updateForBigWidgetView {
	// Update for widget being big
}
-(void)updateForData:(NSDictionary *)data {
	
}
@end