#import "STDispatch.h"

@implementation STDispatch

+ (void)beforeEach {
    [self initialize];
}

+ (void)initialize {
    STDispatch.behavior = STDispatchBehaviorSynchronous;
}

static STDispatchBehavior __behavior;
+ (STDispatchBehavior)behavior {
    return __behavior;
}

+ (void)setBehavior:(STDispatchBehavior)behavior {
    __behavior = behavior;
}

@end
