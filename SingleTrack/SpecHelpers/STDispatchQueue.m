#import "SingleTrack.h"
#import "STDispatchQueue.h"
#import "STDispatch.h"

@interface STDispatchQueue ()

@property (nonatomic, strong) NSMutableArray *tasks;

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
