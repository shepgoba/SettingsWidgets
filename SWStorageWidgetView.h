#import "SWDiskUsageView.h"
#import "SWWidgetView.h"

@interface SWStorageWidgetView : SWWidgetView {
    SWDiskUsageView *_diskUsageView;
}
-(SWDiskUsageView *)diskUsageView;
@end