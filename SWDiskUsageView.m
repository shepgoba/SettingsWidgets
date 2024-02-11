#import "SWDiskUsageView.h"
#import <objc/runtime.h>

extern uint64_t getTotalDiskSpace(void);
extern uint64_t getFreeDiskSpace(void);



UIColor *colorWithRGB(unsigned char red, unsigned char green, unsigned char blue) 
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.0];
}

static inline double GBFromBytes(double bytes) 
{
    return (bytes / (1000 * 1000 * 1000));
}

@implementation SWDiskUsageView
-(UILabel *)usageLabel {
    return _usageLabel;
}
-(UIView *)diskBarView 
{
    return _diskBarView;
}
-(CGSize)intrinsicContentSize 
{
    return CGSizeMake(0, 40);
}
-(void)setup
{
    _backgroundView = [UIView new];
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _backgroundView.layer.cornerRadius = 3;

    _diskBarView = [UIView new];
    _diskBarView.layer.cornerRadius = 3;
    _diskBarView.translatesAutoresizingMaskIntoConstraints = NO;

    _usageLabel = [UILabel new];
    _usageLabel.text = @"-- GB / --- GB";
    _usageLabel.textAlignment = NSTextAlignmentCenter;
    _usageLabel.font = [UIFont boldSystemFontOfSize:9];
    _usageLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview: _backgroundView];
    [self addSubview: _diskBarView];
    [self addSubview: _usageLabel];

    [_backgroundView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant:15].active = YES;
    [_backgroundView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant:-15].active = YES;
    [_backgroundView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-5].active = YES;
    [_backgroundView.topAnchor constraintEqualToAnchor: self.bottomAnchor constant:-12.5].active = YES;


    [_diskBarView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant:15].active = YES;
    //[_diskBarView.widthAnchor constraintEqualToAnchor: _backgroundView.widthAnchor multiplier: diskMultiplier].active = YES;
    //[self.diskBarView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant:-15].active = YES;
    [_diskBarView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant:-5].active = YES;
    [_diskBarView.topAnchor constraintEqualToAnchor: self.bottomAnchor constant:-12.5].active = YES;

    [_usageLabel.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
    [_usageLabel.bottomAnchor constraintEqualToAnchor: _backgroundView.topAnchor constant:-5].active = YES;

    [self setBarBackgroundColor];

}
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setBarBackgroundColor];
}

-(void)setBarBackgroundColor {
    if (@available(iOS 13, *)) {
		if ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleLight) {
			_backgroundView.backgroundColor = colorWithRGB(209, 209, 209);
            _diskBarView.backgroundColor = colorWithRGB(70, 70, 70);
		} else {
            _backgroundView.backgroundColor = colorWithRGB(79, 79, 79);
           _diskBarView.backgroundColor = colorWithRGB(224, 224, 224);
        }
	} else {
        _backgroundView.backgroundColor = colorWithRGB(209, 209, 209);
        _diskBarView.backgroundColor = colorWithRGB(70, 70, 70);
    }
}
-(void)updateDiskBarForUsedDiskSpace:(NSUInteger)usedSpace totalSpace:(NSUInteger)totalSpace {
    _usageLabel.text = [NSString stringWithFormat:@"%.01f GB / %.00f GB", GBFromBytes(usedSpace),GBFromBytes(totalSpace)];
    CGFloat diskMultiplier = (CGFloat)usedSpace / (CGFloat)totalSpace;
    [_diskBarView.widthAnchor constraintEqualToAnchor: _backgroundView.widthAnchor multiplier: diskMultiplier].active = YES;
}
@end

