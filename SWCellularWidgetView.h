#include <ifaddrs.h>
#include <arpa/inet.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SWWidgetView.h"

@interface SWCellularWidgetView : SWWidgetView {
	UILabel *_dataUsageLabel;
	UIActivityIndicatorView *_loadingView;
}
@end
