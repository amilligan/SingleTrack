#import <Foundation/Foundation.h>
#import "STDispatchQueue.h"

#ifdef __cplusplus
extern "C" {
#endif
NSArray *dispatch_queues();
#ifdef __cplusplus
}
#endif


@interface STDispatchQueue : NSObject

- (void)enqueue:(void (^)())task;

@end

@interface STDispatchQueue (Collections)

- (NSArray *)tasks;

@end
