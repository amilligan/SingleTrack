#import "AsyncThing.h"

@interface AsyncThing ()

@property (nonatomic, assign, readwrite) NSInteger value;
@property (nonatomic, strong) dispatch_queue_t queue;

@end


@implementation AsyncThing

- (instancetype)init {
    if (self = [super init]) {
        self.queue = dispatch_queue_create("async thing", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)setValueAsync:(NSInteger)value {
    dispatch_async(self.queue, ^{
        self.value = value;
    });
}

@end
