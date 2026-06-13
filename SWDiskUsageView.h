#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "utils.h"
@interface SWDiskUsageView : UIView {
	UIView *_backgroundView;
	UIView *_diskBarView;
	UILabel *_usageLabel;
}
-(UIView *)diskBarView;
-(UILabel *)usageLabel;
-(void)setup;
-(void)setBarBackgroundColor;
-(void)updateDiskBarForUsedDiskSpace:(NSUInteger)usedSpace totalSpace:(NSUInteger)totalSpace;
@end