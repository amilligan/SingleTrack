#import "SingleTrack/SpecHelpers.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(STDispatchGroupSpec)

describe(@"STDispatchGroup", ^{
    __block dispatch_group_t group;

    beforeEach(^{
        group = dispatch_group_create();
    });

    describe(@"+beforeEach", ^{
        subjectAction(^{ [NSClassFromString(@"STDispatchGroup") performSelector:@selector(beforeEach)]; });

        beforeEach(^{
            dispatch_groups() should_not be_empty;
        });

        it(@"should clear the list of groups", ^{
            dispatch_groups() should be_empty;
        });
    });

    describe(@"dispatch_group_create", ^{
        __block dispatch_group_t group;

        subjectAction(^{ group = dispatch_group_create(); });

        it(@"should add the group to the list of instantiated groups", ^{
            dispatch_groups() should contain(group);
        });
    });

    describe(@"dispatch_group_async", ^{
        __block dispatch_queue_t queue;
        id task = ^{};

        subjectAction(^{ dispatch_group_async(group, queue, task); });

        beforeEach(^{
            STDispatch.behavior = STDispatchBehaviorManual;
            queue = dispatch_queue_create("a queue", DISPATCH_QUEUE_CONCURRENT);
        });

        it(@"should enqueue the block on the queue", ^{
            dispatch_queue_tasks(queue) should contain(task);
        });
    });
});

SPEC_END
