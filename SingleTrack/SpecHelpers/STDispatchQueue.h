#import <Foundation/Foundation.h>
#import "STDispatchQueue.h"

#ifdef __cplusplus
extern "C" {
#endif
NSArray *dispatch_queues();
NSArray *dispatch_queue_tasks(dispatch_queue_t);
void dispatch_execute_next_task(dispatch_queue_t);
void dispatch_execute_task_at_index(dispatch_queue_t, uint8_t);
void dispatch_execute_all_tasks(dispatch_queue_t);
#ifdef __cplusplus
}
#endif


@interface STDispatchQueue : NSObject

@property (nonatomic, strong, readonly) NSString *label;
@property (nonatomic, assign, readonly) BOOL isConcurrent;

- (instancetype)initWithLabel:(const char *)label attr:(dispatch_queue_attr_t)attr;
- (void)enqueue:(void (^)())task;

@end

@interface STDispatchQueue (Collections)

- (NSArray *)tasks;

@end
