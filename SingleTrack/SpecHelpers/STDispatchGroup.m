#import "SingleTrack.h"
#import "STDispatchGroup.h"
#import "STDispatch.h"

@interface STDispatchGroup ()

@property (nonatomic, strong) NSMutableArray *tasks;

+ (NSMutableArray *)groups;

@end

static dispatch_group_t (*real_dispatch_group_create)(void);
dispatch_group_t st_dispatch_group_create(void) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        return real_dispatch_group_create();
    } else {
        STDispatchGroup *group = [[STDispatchGroup alloc] init];
        [STDispatchGroup.groups addObject:group];
        return (dispatch_group_t)group;
    }
}

static void (*real_dispatch_group_async)(dispatch_group_t, dispatch_queue_t, dispatch_block_t);
void st_dispatch_group_async(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block) {
    if (STDispatch.behavior == STDispatchBehaviorAsynchronous) {
        real_dispatch_group_async(group, queue, block);
    } else {
        [(id)queue enqueue:block];
        [(id)group enqueue:block];
    }
}

@implementation STDispatchGroup

+ (void)beforeEach {
    [self.groups removeAllObjects];
}

+ (void)initialize {
    real_dispatch_group_create = proxy_dispatch_group_create;
    proxy_dispatch_group_create = st_dispatch_group_create;

    real_dispatch_group_async = proxy_dispatch_group_async;
    proxy_dispatch_group_async = st_dispatch_group_async;
}

+ (NSMutableArray *)groups {
    static NSMutableArray *__groups;
    if (!__groups) {
        __groups = [NSMutableArray array];
    }
    return __groups;
}

- (instancetype)init {
    if (self = [super init]) {
        self.tasks = [NSMutableArray array];
    }
    return self;
}

- (void)enqueue:(void (^)())task {
    [self.tasks addObject:task];
}

@end
