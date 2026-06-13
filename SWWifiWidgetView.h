#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "SWWidgetView.h"

@interface SWWifiWidgetView : SWWidgetView
@property (nonatomic, strong) UILabel *ipAddressLabel;
@end