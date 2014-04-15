#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif
NSArray *dispatch_groups();
#ifdef __cplusplus
}
#endif


@interface STDispatchGroup : NSObject

- (void)enqueue:(void (^)())task;

@end

@interface STDispatchGroup (Collections)

- (NSArray *)tasks;

@end
