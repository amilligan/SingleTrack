#import "AsyncThing.h"

@interface AsyncThing ()

@property (nonatomic, assign, readwrite) NSInteger value;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_group_t group;

@end


@implementation AsyncThing

- (instancetype)init {
    if (self = [super init]) {
        self.queue = dispatch_queue_create("async thing", DISPATCH_QUEUE_CONCURRENT);
        self.group = dispatch_group_create();
    }
    return self;
}

- (void)setValueAsync:(NSInteger)value {
    dispatch_async(self.queue, ^{
        self.value = value;
    });
}

- (void)setValueGroupAsync:(NSInteger)value {
    dispatch_group_async(self.group, self.queue, ^{
        self.value = value;
    });
}

@end
