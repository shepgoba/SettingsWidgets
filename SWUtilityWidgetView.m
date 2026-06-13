#import "SWUtilityWidgetView.h"
#import "SWUtils.h"


inline UIColor *colorWithRGB(unsigned char red, unsigned char green, unsigned char blue) {
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.0];
}

@interface UIView (lazyBonusRoute)
-(id)_viewControllerForAncestor;
@end

@implementation SWUtilityWidgetView
-(NSString *)iconImage {
	return @"utilityicon";
}
-(NSString *)widgetHeaderLocalizationString {
	return @"UTILITY_WIDGET_HEADER";
}
-(void)additionalSetup {
	self.hasPrefsURL = NO;
	_respringView = [[UIView alloc] init];

	_respringView.layer.cornerRadius = 14;
	_respringView.translatesAutoresizingMaskIntoConstraints = NO;

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respringButtonTapped:)];
	[_respringView addGestureRecognizer:tapGestureRecognizer];
	

	UIActivityIndicatorView *respringIcon = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
	respringIcon.translatesAutoresizingMaskIntoConstraints = NO;
	respringIcon.hidesWhenStopped = NO;

	[_respringView addSubview:respringIcon];

	[respringIcon.centerXAnchor constraintEqualToAnchor: _respringView.centerXAnchor].active = YES;
	[respringIcon.centerYAnchor constraintEqualToAnchor: _respringView.centerYAnchor].active = YES;


	[self addSubview:_respringView];

	[_respringView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10].active = YES;
	[_respringView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -10].active = YES;
	[_respringView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5 constant:-15].active = YES;
	[_respringView.heightAnchor constraintEqualToConstant:28].active = YES;


	_secondView = [[UIView alloc] init];
	_secondView.layer.cornerRadius = 14;
	_secondView.translatesAutoresizingMaskIntoConstraints = NO;
	

	
	UITapGestureRecognizer *secondViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondViewTapped:)];
	[_secondView addGestureRecognizer:secondViewTapGestureRecognizer];

	[self addSubview:_secondView];

	[_secondView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10].active = YES;
	[_secondView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10].active = YES;
	[_secondView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5 constant:-15].active = YES;
	[_secondView.heightAnchor constraintEqualToConstant:28].active = YES;

	[self updateUtilityButtonBackgrounds];

}

-(void)respringButtonTapped:(UIGestureRecognizer *)sender {
	UIViewController *cont = [self _viewControllerForAncestor];
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Respring Device?"
		message:nil
		preferredStyle:UIAlertControllerStyleAlert];
		
	void (^respringAction)(UIAlertAction *) = ^void(UIAlertAction *action) {
		[SWUtils respringDevice];
	};

	UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" 
		style:UIAlertActionStyleDestructive 
		handler:respringAction];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
		style:UIAlertActionStyleDefault 
		handler:nil];

	[alert addAction:defaultAction];
	[alert addAction:cancelAction];
	[cont presentViewController:alert animated:YES completion:nil];
}

-(void)secondViewTapped:(UIGestureRecognizer *)sender {

}


-(void)updateUtilityButtonBackgrounds {
	if (@available(iOS 13, *)) {
		if ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark) {
			_respringView.backgroundColor = colorWithRGB(10, 10, 10);
			_secondView.backgroundColor = colorWithRGB(10, 10, 10);
		} else {
			_respringView.backgroundColor = colorWithRGB(200, 200, 200);
			_secondView.backgroundColor = colorWithRGB(200, 200, 200);
		}
	} else {
		_respringView.backgroundColor = colorWithRGB(200, 200, 200);
		_secondView.backgroundColor = colorWithRGB(200, 200, 200);
	}
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
	[self updateUtilityButtonBackgrounds];
}
@end
