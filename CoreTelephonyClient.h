@interface CoreTelephonyClient : NSObject {

	id _delegate;
	id _userQueue;
	id _mux;
}
@property (assign,nonatomic) id userQueue;                          //@synthesize userQueue=_userQueue - In the implementation block
@property (nonatomic,retain) id mux;              //@synthesize mux=_mux - In the implementation block
@property (assign,nonatomic) id delegate;                        //@synthesize delegate=_delegate - In the implementation block
+(instancetype)sharedMultiplexer;
-(id)proxyWithErrorHandler:(/*^block*/id)arg1 ;
-(void)dataUsageForLastPeriods:(unsigned long long)arg1 completion:(/*^block*/id)arg2 ;

@end
