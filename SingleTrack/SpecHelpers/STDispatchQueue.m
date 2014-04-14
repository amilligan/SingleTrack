#import "SingleTrack.h"
#import "STDispatchQueue.h"
#import "STDispatch.h"

@interface STDispatchQueue ()

@property (nonatomic, strong) NSMutableArray *tasks;

+ (NSMutableArray *)queues;

@end

static dispatch_queue_t (*real_dispatch_queue_create)(const char *, dispatch_queue_attr_t);
dispatch_queue_t st_dispatch_queue_create(const char *label, dispatch_queue_attr_t attr) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        return real_dispatch_queue_create(label, attr);
    } else {
        STDispatchQueue *queue = [[STDispatchQueue alloc] init];
        [STDispatchQueue.queues addObject:queue];
        return (dispatch_queue_t)queue;
    }
}

static void (*real_dispatch_async)(dispatch_queue_t, dispatch_block_t);
void st_dispatch_async(dispatch_queue_t queue, dispatch_block_t block) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        real_dispatch_async(queue, block);
    } else {
        [(id)queue enqueue:block];
    }
}

@implementation STDispatchQueue

+ (void)beforeEach {
    [self.queues removeAllObjects];
}

+ (void)initialize {
    real_dispatch_queue_create = proxy_dispatch_queue_create;
    proxy_dispatch_queue_create = st_dispatch_queue_create;

    real_dispatch_async = proxy_dispatch_async;
    proxy_dispatch_async = st_dispatch_async;
}

+ (NSMutableArray *)queues {
    static NSMutableArray *__queues;
    if (!__queues) {
        __queues = [NSMutableArray array];
    }
    return __queues;
}

- (instancetype)init {
    if (self = [super init]) {
        self.tasks = [NSMutableArray array];
    }
    return self;
}

- (void)enqueue:(void (^)())task {
    if (STDispatch.behavior == STDispatchBehaviorSynchronous) {
        task();
    } else if (STDispatch.behavior == STDispatchBehaviorManual) {
        [self.tasks addObject:task];
    }
}

@end
