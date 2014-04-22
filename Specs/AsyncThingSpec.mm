#import "AsyncThing.h"
#import "SingleTrack/SpecHelpers.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AsyncThingSpec)

describe(@"AsyncThing", ^{
    __block AsyncThing *thing;

    beforeEach(^{
        STDispatch.behavior = STDispatchBehaviorManual;
        thing = [[AsyncThing alloc] init];
    });

    describe(@"-setValueAsync:", ^{
        NSUInteger value = 7;

        subjectAction(^{ [thing setValueAsync:value]; });

        it(@"should not immediately set the value (due to interaction with SingleTrack)", ^{
            thing.value should_not equal(value);
        });

        it(@"should set the value when the asynchronous task is explicitly run", ^{
            dispatch_queue_t queue = dispatch_queues().firstObject;
            dispatch_execute_all_tasks(queue);

            thing.value should equal(value);
        });
    });
});

SPEC_END
