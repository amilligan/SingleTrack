#import "SingleTrack.h"
#import "STDispatchQueue.h"
#import "STDispatch.h"

@interface STDispatchQueue ()

@property (nonatomic, strong) NSString *label;
@property (nonatomic, assign, readwrite) BOOL isConcurrent;
@property (nonatomic, strong) NSMutableArray *tasks;

+ (NSMutableArray *)queues;
- (void)executeNextTask;
- (void)executeTaskAtIndex:(uint8_t)index;
- (void)executeAllTasks;

@end

static NSMutableArray *__queues;
NSArray *dispatch_queues() {
    if (!__queues) {
        __queues = [NSMutableArray array];
    }
    return __queues;
}

void dispatch_execute_next_task(dispatch_queue_t queue) {
    [((STDispatchQueue *)queue) executeNextTask];
}

void dispatch_execute_task_at_index(dispatch_queue_t queue, uint8_t index) {
    [((STDispatchQueue *)queue) executeTaskAtIndex:index];
}

void dispatch_execute_all_tasks(dispatch_queue_t queue) {
    [((STDispatchQueue *)queue) executeAllTasks];
}

static dispatch_queue_t (*real_dispatch_queue_create)(const char *, dispatch_queue_attr_t);
static dispatch_queue_t st_dispatch_queue_create(const char *label, dispatch_queue_attr_t attr) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        return real_dispatch_queue_create(label, attr);
    } else {
        STDispatchQueue *queue = [[STDispatchQueue alloc] initWithLabel:label attr:attr];
        [STDispatchQueue.queues addObject:queue];
        return (dispatch_queue_t)queue;
    }
}

static id __mainQueue;
static dispatch_queue_t (*real_dispatch_get_main_queue)(void);
static dispatch_queue_t st_dispatch_get_main_queue(void) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        return real_dispatch_get_main_queue();
    } else {
        if (!__mainQueue) {
            __mainQueue = dispatch_queue_create("MAIN QUEUE", DISPATCH_QUEUE_SERIAL);
        }
        return __mainQueue;
    }
}

static id __highPriorityQueue;
static id __defaultPriorityQueue;
static id __lowPriorityQueue;
static id __backgroundPriorityQueue;
static dispatch_queue_t build_global_queue(const char *label, id __strong *queue) {
    if (!*queue) {
        *queue = dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT);
    }
    return *queue;
}

static dispatch_queue_t (*real_dispatch_get_global_queue)(dispatch_queue_priority_t, unsigned long);
static dispatch_queue_t st_dispatch_get_global_queue(dispatch_queue_priority_t priority, unsigned long flags) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        return real_dispatch_get_global_queue(priority, flags);
    } else {
        switch (priority) {
            case DISPATCH_QUEUE_PRIORITY_HIGH:
                return build_global_queue("HIGH PRIORITY QUEUE", &__highPriorityQueue);
            case DISPATCH_QUEUE_PRIORITY_DEFAULT:
                return build_global_queue("DEFAULT PRIORITY QUEUE", &__defaultPriorityQueue);
            case DISPATCH_QUEUE_PRIORITY_LOW:
                return build_global_queue("LOW PRIORITY QUEUE", &__lowPriorityQueue);
            case DISPATCH_QUEUE_PRIORITY_BACKGROUND:
                return build_global_queue("BACKGROUND PRIORITY QUEUE", &__backgroundPriorityQueue);
            default:
                @throw [NSString stringWithFormat:@"Cannot create global queue with unknown priority: %ld", priority];
        }
    }
}

static void (*real_dispatch_async)(dispatch_queue_t, dispatch_block_t);
static void st_dispatch_async(dispatch_queue_t queue, dispatch_block_t block) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        real_dispatch_async(queue, block);
    } else {
        [(id)queue enqueue:block];
    }
}

@implementation STDispatchQueue

+ (void)beforeEach {
    [__queues removeAllObjects];
    __mainQueue =
    __highPriorityQueue =
    __defaultPriorityQueue =
    __lowPriorityQueue =
    __backgroundPriorityQueue = nil;
}

+ (void)initialize {
    real_dispatch_queue_create = proxy_dispatch_queue_create;
    proxy_dispatch_queue_create = st_dispatch_queue_create;

    real_dispatch_get_main_queue = proxy_dispatch_get_main_queue;
    proxy_dispatch_get_main_queue = st_dispatch_get_main_queue;

    real_dispatch_get_global_queue = proxy_dispatch_get_global_queue;
    proxy_dispatch_get_global_queue = st_dispatch_get_global_queue;

    real_dispatch_async = proxy_dispatch_async;
    proxy_dispatch_async = st_dispatch_async;
}

+ (NSMutableArray *)queues {
    if (!__queues) { dispatch_queues(); }
    return __queues;
}

- (instancetype)initWithLabel:(const char *)label attr:(dispatch_queue_attr_t)attr {
    if (self = [super init]) {
        self.label = [NSString stringWithCString:label encoding:NSUTF8StringEncoding];
        self.isConcurrent = attr == DISPATCH_QUEUE_CONCURRENT;
        self.tasks = [NSMutableArray array];
    }
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd]; return nil;
}

- (void)enqueue:(void (^)())task {
    if (STDispatch.behavior == STDispatchBehaviorSynchronous) {
        task();
    } else if (STDispatch.behavior == STDispatchBehaviorManual) {
        [self.tasks addObject:task];
    }
}

- (void)executeNextTask {
    if (self.isConcurrent) {
        @throw [NSString stringWithFormat:@"Cannot dispatch_execute_next_task on concurrent queue: %@", self.label];
    } else if (!self.tasks.count) {
        @throw [NSString stringWithFormat:@"Cannot dispatch_execute_next_task on empty queue '%@' (did you mean to set the dispatch behavior to manual?)", self.label];
    } else {
        dispatch_block_t task = self.tasks.firstObject;
        task();
        [self.tasks removeObjectAtIndex:0];
    }
}

- (void)executeTaskAtIndex:(uint8_t)index {
    if (!self.isConcurrent) {
        @throw [NSString stringWithFormat:@"Cannot dispatch_execute_task_at_index on serial queue: %@", self.label];
    } else if (index >= self.tasks.count) {
        @throw [NSString stringWithFormat:@"Cannot dispatch_execute_task_at_index on out of bounds index (%d) in queue '%@'", index, self.label];
    } else {
        dispatch_block_t task = [self.tasks objectAtIndex:index];
        task();
        [self.tasks removeObjectAtIndex:index];
    }
}

- (void)executeAllTasks {
    if (self.isConcurrent) {
        while (self.tasks.count) {
            uint32_t index = arc4random_uniform((uint32_t)self.tasks.count);
            dispatch_block_t task = self.tasks[index];
            task();
            [self.tasks removeObjectAtIndex:index];
        }
    } else {
        [self.tasks enumerateObjectsUsingBlock:^(dispatch_block_t task, NSUInteger idx, BOOL *stop) {
            task();
        }];
        [self.tasks removeAllObjects];
    }
}

@end
