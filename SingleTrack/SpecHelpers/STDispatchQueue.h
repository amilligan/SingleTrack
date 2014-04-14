#import <Foundation/Foundation.h>
#import "STDispatchQueue.h"

@interface STDispatchQueue : NSObject

- (void)enqueue:(void (^)())task;

@end

@interface STDispatchQueue (Collections)

+ (NSArray *)queues;
- (NSArray *)tasks;

@end
