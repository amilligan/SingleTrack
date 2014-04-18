#import "SingleTrack/SpecHelpers.h"
#import "AsyncThing.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(STDispatchQueueSpec)

describe(@"STDispatchQueue", ^{
    __block STDispatchQueue *queue;
    const char *label = "my queue";

    beforeEach(^{
        queue = [[STDispatchQueue alloc] initWithLabel:label attr:DISPATCH_QUEUE_CONCURRENT];
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

    describe(@"-label", ^{
        it(@"should be the given label, NSString-ified", ^{
            queue.label should equal([NSString stringWithCString:label encoding:NSUTF8StringEncoding]);
        });
    });

    describe(@"-isConcurrent", ^{
        context(@"when initialized with DISPATCH_QUEUE_CONCURRENT", ^{
            beforeEach(^{
                queue = [[STDispatchQueue alloc] initWithLabel:"queue1" attr:DISPATCH_QUEUE_CONCURRENT];
            });

            it(@"should be true", ^{
                queue.isConcurrent should be_truthy;
            });
        });

        context(@"when initialized with DISPATCH_QUEUE_SERIAL", ^{
            beforeEach(^{
                queue = [[STDispatchQueue alloc] initWithLabel:"queue1" attr:DISPATCH_QUEUE_SERIAL];
            });

            it(@"should not be true", ^{
                queue.isConcurrent should_not be_truthy;
            });
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

    describe(@"dispatch_execute_next_task", ^{
        __block dispatch_queue_t queue;

        subjectAction(^{ dispatch_execute_next_task(queue); });

        beforeEach(^{
            STDispatch.behavior = STDispatchBehaviorManual;
        });

        context(@"with a serial queue", ^{
            beforeEach(^{
                queue = dispatch_queue_create("a serial queue", DISPATCH_QUEUE_SERIAL);
            });

            context(@"with no tasks in the queue", ^{
                beforeEach(^{
                    ((STDispatchQueue *)queue).tasks should be_empty;
                });

                itShouldRaiseException();
            });

            context(@"with tasks in the queue", ^{
                __block NSInteger value, one = 1, two = 2;

                beforeEach(^{
                    dispatch_async(queue, ^{ value = one; });
                    dispatch_async(queue, ^{ value = two; });
                });

                it(@"should execute one task in a FIFO fashion", ^{
                    value should equal(one);
                });

                it(@"should remove the executed task from the queue", ^{
                    ((STDispatchQueue *)queue).tasks.count should equal(1);
                });
            });
        });

        context(@"with a concurrent queue", ^{
            beforeEach(^{
                queue = dispatch_queue_create("a concurrent queue", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(queue, ^{});
            });

            itShouldRaiseException();
        });
    });

    describe(@"dispatch_execute_task_at_index", ^{
        __block dispatch_queue_t queue;
        __block int16_t index;

        subjectAction(^{ dispatch_execute_task_at_index(queue, index); });

        beforeEach(^{
            STDispatch.behavior = STDispatchBehaviorManual;
        });

        context(@"with a concurrent queue", ^{
            beforeEach(^{
                queue = dispatch_queue_create("a concurrent queue", DISPATCH_QUEUE_CONCURRENT);
            });

            context(@"with no tasks in the queue", ^{
                beforeEach(^{
                    ((STDispatchQueue *)queue).tasks should be_empty;
                });

                itShouldRaiseException();
            });

            context(@"with tasks in the queue", ^{
                __block NSInteger value;
                id block0 = ^{ value = 0; }, block1 = ^{ value = 1; };

                beforeEach(^{
                    dispatch_async(queue, block0);
                    dispatch_async(queue, block1);
                });

                context(@"with an index within the bounds of queued tasks", ^{
                    beforeEach(^{
                        index = 1;
                    });

                    it(@"should execute the task at the specified index", ^{
                        value should equal(1);
                    });

                    it(@"should remove the executed task from the queue", ^{
                        ((STDispatchQueue *)queue).tasks should_not contain(block1);
                    });
                });

                context(@"with an index outside the bounds of queued tasks", ^{
                    beforeEach(^{
                        index = 2;
                    });

                    itShouldRaiseException();
                });
            });
        });

        context(@"with a serial queue", ^{
            beforeEach(^{
                queue = dispatch_queue_create("a serial queue", DISPATCH_QUEUE_SERIAL);
                dispatch_async(queue, ^{});
            });

            itShouldRaiseException();
        });
    });

    describe(@"dispatch_execute_all_tasks", ^{
        __block dispatch_queue_t queue;
        __block NSInteger value;
        id block0 = ^{ value = 0; }, block1 = ^{ value = 1; };

        subjectAction(^{ dispatch_execute_all_tasks(queue); });

        beforeEach(^{
            STDispatch.behavior = STDispatchBehaviorManual;
        });

        context(@"with a concurrent queue", ^{
            beforeEach(^{
                queue = dispatch_queue_create("a concurrent queue", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(queue, block0);
                dispatch_async(queue, block1);
            });

            it(@"should remove all tasks from the queue", ^{
                ((STDispatchQueue *)queue).tasks should be_empty;
            });

            it(@"should run the tasks in nondeterministic order", ^{
                NSInteger previousValue = value;
                BOOL same = YES;
                for (unsigned int i = 0; i < 20; ++i) {
                    dispatch_async(queue, block0);
                    dispatch_async(queue, block1);
                    dispatch_execute_all_tasks(queue);

                    same = same && (value == previousValue);
                    previousValue = value;
                }
                same should_not be_truthy;
            });
        });

        context(@"with a serial queue", ^{
            beforeEach(^{
                queue = dispatch_queue_create("a serial queue", DISPATCH_QUEUE_SERIAL);
                for (unsigned int i = 0; i < 20; ++i) {
                    dispatch_async(queue, block0);
                }
                dispatch_async(queue, block1);
            });

            it(@"should remove all tasks from the queue", ^{
                ((STDispatchQueue *)queue).tasks should be_empty;
            });

            it(@"should run the tasks in order", ^{
                value should equal(1);
            });
        });
    });

    describe(@"dispatch_get_main_queue", ^{
        __block dispatch_queue_t queue;

        subjectAction(^{ queue = dispatch_get_main_queue(); });

        it(@"should return a serial queue", ^{
            ((STDispatchQueue *)queue).isConcurrent should_not be_truthy;
        });

        it(@"should always return the same queue", ^{
            dispatch_get_main_queue() should be_same_instance_as(queue);
        });

        it(@"should add the queue to the list of queues", ^{
            dispatch_queues() should contain(dispatch_get_main_queue());
        });
    });
});

SPEC_END
