#import "SWUtils.h"

typedef NS_OPTIONS(NSUInteger, SBSRelaunchActionOptions) {
	SBSRelaunchActionOptionsNone,
	SBSRelaunchActionOptionsRestartRenderServer = 1 << 0,
	SBSRelaunchActionOptionsSnapshotTransition = 1 << 1,
	SBSRelaunchActionOptionsFadeToBlackTransition = 1 << 2
};

@interface FBSSystemService : NSObject
+(instancetype)sharedService;
-(void)sendActions:(id)arg1 withResult:(id)arg2;
@end

@interface SBSRelaunchAction : NSObject
@property (nonatomic,copy,readonly) NSString * reason; 
@property (nonatomic,readonly) unsigned long long options; 
@property (nonatomic,retain,readonly) NSURL * targetURL; 
+(id)actionWithReason:(id)arg1 options:(unsigned long long)arg2 targetURL:(id)arg3 ;
-(id)initWithReason:(id)arg1 options:(unsigned long long)arg2 targetURL:(id)arg3 ;
-(NSURL *)targetURL;
-(NSString *)reason;
-(unsigned long long)options;
@end

@implementation SWUtils
+(void)respringDevice {
    SBSRelaunchAction *restartAction = [SBSRelaunchAction actionWithReason:@"RestartRenderServer" options:SBSRelaunchActionOptionsFadeToBlackTransition targetURL:nil];
    [[FBSSystemService sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
}
@end