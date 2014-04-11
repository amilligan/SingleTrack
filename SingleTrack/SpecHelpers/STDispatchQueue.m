#import "SingleTrack.h"
#import "STDispatchQueue.h"

@interface STDispatchQueue ()

+ (NSMutableArray *)queues;

@end

dispatch_queue_t st_dispatch_queue_create(const char *label, dispatch_queue_attr_t attr) {
    STDispatchQueue *queue = [[STDispatchQueue alloc] init];
    [STDispatchQueue.queues addObject:queue];
    return (dispatch_queue_t)queue;
}

@implementation STDispatchQueue

+ (void)initialize {
    dispatch_queue_create_proxy = st_dispatch_queue_create;
}

+ (NSMutableArray *)queues {
    static NSMutableArray *__queues;
    if (!__queues) {
        __queues = [NSMutableArray array];
    }
    return __queues;
}

@end
