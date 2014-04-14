#import <Foundation/Foundation.h>

@interface STDispatchGroup : NSObject

- (void)enqueue:(void (^)())task;

@end

@interface STDispatchGroup (Collections)

+ (NSArray *)groups;
- (NSArray *)tasks;

@end
