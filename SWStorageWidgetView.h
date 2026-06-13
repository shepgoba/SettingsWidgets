#import "SWDiskUsageView.h"
#import "SWWidgetView.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SWStorageWidgetView : SWWidgetView {
    SWDiskUsageView *_diskUsageView;
}
-(SWDiskUsageView *)diskUsageView;
@end