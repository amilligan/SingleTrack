#import <Foundation/Foundation.h>
#import "STDispatchQueue.h"

#ifdef __cplusplus
extern "C" {
#endif

NSArray *dispatch_queues();
bool dispatch_queue_is_concurrent(dispatch_queue_t);
NSArray *dispatch_queue_tasks(dispatch_queue_t);
void dispatch_execute_next_task(dispatch_queue_t);
void dispatch_execute_task_at_index(dispatch_queue_t, uint8_t);
void dispatch_execute_all_tasks(dispatch_queue_t);

#ifdef __cplusplus
}
#endif
