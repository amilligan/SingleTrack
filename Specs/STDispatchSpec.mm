#import "SingleTrack/SpecHelpers.h"
#import "STDispatch.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(STDispatchSpec)

describe(@"STDispatch", ^{
    describe(@"+behavior", ^{
        it(@"should default to STDispatchBehaviorSynchronous", ^{
            STDispatch.behavior should equal(STDispatchBehaviorSynchronous);
        });
    });

    describe(@"+beforeEach", ^{
        subjectAction(^{ [[STDispatch class] performSelector:@selector(beforeEach)]; });

        beforeEach(^{
            STDispatch.behavior = STDispatchBehaviorManual;
        });

        it(@"should reset the behavior to the default", ^{
            STDispatch.behavior should equal(STDispatchBehaviorSynchronous);
        });
    });

    describe(@"+setBehavior:", ^{
        __block STDispatchBehavior newBehavior;
        void (^subject)() = ^{ STDispatch.behavior = newBehavior; };

        context(@"from Synchronous", ^{
            beforeEach(^{ STDispatch.behavior = STDispatchBehaviorSynchronous; });

            context(@"with no queues or groups", ^{
                context(@"to Synchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorSynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Manual", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorManual; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Asynchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorAsynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });
            });

            context(@"after creating a queue", ^{
                __block dispatch_queue_t queue;

                beforeEach(^{
                    queue = dispatch_queue_create("wibble", DISPATCH_QUEUE_SERIAL);
                });

                context(@"to Synchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorSynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Manual", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorManual; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Asynchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorAsynchronous; });
                    it(@"should throw an exception", ^{
                        subject should raise_exception;
                    });
                });
            });

            context(@"after creating a group", ^{
                __block dispatch_group_t group;

                beforeEach(^{
                    group = dispatch_group_create();
                });

                context(@"to Synchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorSynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Manual", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorManual; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Asynchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorAsynchronous; });
                    it(@"should throw an exception", ^{
                        subject should raise_exception;
                    });
                });
            });
        });

        context(@"from Manual", ^{
            beforeEach(^{ STDispatch.behavior = STDispatchBehaviorManual; });

            context(@"with no queues or groups", ^{
                context(@"to Synchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorSynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Manual", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorManual; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Asynchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorAsynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });
            });

            context(@"after creating a queue", ^{
                __block dispatch_queue_t queue;

                beforeEach(^{
                    queue = dispatch_queue_create("wibble", DISPATCH_QUEUE_SERIAL);
                });

                context(@"to Synchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorSynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Manual", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorManual; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Asynchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorAsynchronous; });
                    it(@"should throw an exception", ^{
                        subject should raise_exception;
                    });
                });
            });

            context(@"after creating a group", ^{
                __block dispatch_group_t group;

                beforeEach(^{
                    group = dispatch_group_create();
                });

                context(@"to Synchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorSynchronous; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Manual", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorManual; });
                    it(@"should not throw an exception", ^{
                        subject should_not raise_exception;
                    });
                });

                context(@"to Asynchronous", ^{
                    beforeEach(^{ newBehavior = STDispatchBehaviorAsynchronous; });
                    it(@"should throw an exception", ^{
                        subject should raise_exception;
                    });
                });
            });
        });

        context(@"from Asynchronous", ^{
            beforeEach(^{ STDispatch.behavior = STDispatchBehaviorAsynchronous; });

            context(@"to Synchronous", ^{
                beforeEach(^{ newBehavior = STDispatchBehaviorSynchronous; });
                it(@"should throw an exception", ^{
                    subject should raise_exception;
                });
            });

            context(@"to Manual", ^{
                beforeEach(^{ newBehavior = STDispatchBehaviorManual; });
                it(@"should throw an exception", ^{
                    subject should raise_exception;
                });
            });

            context(@"to Asynchronous", ^{
                beforeEach(^{ newBehavior = STDispatchBehaviorAsynchronous; });
                it(@"should not throw an exception", ^{
                    subject should_not raise_exception;
                });
            });
        });
    });
});

SPEC_END
