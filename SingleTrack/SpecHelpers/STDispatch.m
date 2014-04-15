#import "STDispatch.h"
#import "STDispatchQueue.h"
#import "STDispatchGroup.h"

@implementation STDispatch

+ (void)beforeEach {
    [self initialize];
}

+ (void)initialize {
    [STDispatch setBehaviorWithoutSafetyCheck:STDispatchBehaviorSynchronous];
}

static STDispatchBehavior __behavior;
+ (STDispatchBehavior)behavior {
    return __behavior;
}

+ (void)setBehavior:(STDispatchBehavior)behavior {
    [self safetyCheckForBehavior:behavior];
    __behavior = behavior;
}

+ (void)setBehaviorWithoutSafetyCheck:(STDispatchBehavior)behavior {
    __behavior = behavior;
}

+ (void)safetyCheckForBehavior:(STDispatchBehavior)newBehavior {
    if (self.behavior == STDispatchBehaviorAsynchronous && newBehavior != STDispatchBehaviorAsynchronous) {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Once you go asynchronous you may not go back!" userInfo:nil] raise];
    } else if ((dispatch_queues().count || dispatch_groups().count) && self.behavior != STDispatchBehaviorAsynchronous && newBehavior == STDispatchBehaviorAsynchronous) {
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempt to mix asynchronous and synchronous behaviors" userInfo:nil] raise];
    }
}

@end
