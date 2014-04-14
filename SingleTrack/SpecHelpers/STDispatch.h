#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    STDispatchBehaviorSynchronous,
    STDispatchBehaviorManual,
    STDispatchBehaviorAsynchronous,
} STDispatchBehavior;


@interface STDispatch : NSObject

+ (STDispatchBehavior)behavior;
+ (void)setBehavior:(STDispatchBehavior)behavior;

@end
