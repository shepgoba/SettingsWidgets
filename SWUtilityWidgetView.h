#import "SWWidgetView.h"
#import "utils.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface SWUtilityWidgetView : SWWidgetView {
    UIView *_respringView;
    UIView *_secondView;

}
-(void)updateUtilityButtonBackgrounds;
@end