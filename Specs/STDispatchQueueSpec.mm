#import "STDispatchQueue.h"
#import "STDispatch.h"
#import "AsyncThing.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(STDispatchQueueSpec)

describe(@"STDispatchQueue", ^{
    __block STDispatchQueue *queue;

    beforeEach(^{
        queue = [[STDispatchQueue alloc] init];
    });

    describe(@"+queues", ^{
        it(@"should default to empty", ^{
            STDispatchQueue.queues should be_empty;
        });
    });

    describe(@"-enqueue", ^{
        __block NSInteger value;
        NSInteger newValue = 7;
        id block = ^{ value = newValue; };

        subjectAction(^{ [queue enqueue:block]; });

        beforeEach(^{
            value = 0;
        });

        context(@"with synchronous dispatch behavior (the default)", ^{
            beforeEach(^{
                STDispatch.behavior = STDispatchBehaviorSynchronous;
            });

            it(@"should execute immediately", ^{
                value should equal(newValue);
            });

            it(@"should not add the block to the list of tasks waiting for execution", ^{
                queue.tasks should be_empty;
            });
        });

        context(@"with manual dispatch behavior", ^{
            beforeEach(^{
                STDispatch.behavior = STDispatchBehaviorManual;
            });

            it(@"should not execute immediately", ^{
                value should_not equal(newValue);
            });

            it(@"should add the block to the list of tasks waiting for execution", ^{
                queue.tasks should contain(block);
            });
        });

        context(@"with asynchronous (multi-thread) dispatch behavior", ^{
            beforeEach(^{
                STDispatch.behavior = STDispatchBehaviorAsynchronous;
            });

            it(@"should not execute immediately", ^{
                value should_not equal(newValue);
            });

            it(@"should not add the block to the list of tasks waiting for execution", ^{
                queue.tasks should be_empty;
            });
        });
    });

    describe(@"dispatch_queue_create", ^{
        __block AsyncThing *thing;

        // AsyncThing instantiates a queue in the initializer
        subjectAction(^{ thing = [[AsyncThing alloc] init]; });

        it(@"should add the queue to the list of instantiated queues", ^{
            STDispatchQueue.queues should contain(thing.queue);
        });
    });
});

SPEC_END
