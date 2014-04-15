#import "SingleTrack/SpecHelpers.h"
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

    describe(@"+beforeEach", ^{
        __block AsyncThing *thing;

        subjectAction(^{ [[STDispatchQueue class] performSelector:@selector(beforeEach)]; });

        beforeEach(^{
            thing = [[AsyncThing alloc] init];
            dispatch_queues() should_not be_empty;
        });

        it(@"should clear the list of queues", ^{
            dispatch_queues() should be_empty;
        });
    });

    describe(@"+queues", ^{
        it(@"should default to empty", ^{
            dispatch_queues() should be_empty;
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
            dispatch_queues() should contain(thing.queue);
        });
    });

    describe(@"dispatch_async", ^{
        __block AsyncThing *thing;

        subjectAction(^{ [thing setValueAsync:7]; });

        beforeEach(^{
            STDispatch.behavior = STDispatchBehaviorManual;
            thing = [[AsyncThing alloc] init];
        });

        it(@"should enqueue the provided block on the queue", ^{
            [(id)thing.queue tasks] should_not be_empty;
        });
    });

    describe(@"dispatch_get_main_queue", ^{
        __block dispatch_queue_t queue;

        subjectAction(^{ queue = dispatch_get_main_queue(); });

        it(@"should return a serial queue", PENDING);
        it(@"should always return the same queue", ^{
            dispatch_get_main_queue() should be_same_instance_as(queue);
        });

        it(@"should add the queue to the list of queues", ^{
            dispatch_queues() should contain(dispatch_get_main_queue());
        });
    });
});

SPEC_END
