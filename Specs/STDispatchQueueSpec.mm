#import "STDispatchQueue.h"
#import "AsyncThing.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(STDispatchQueueSpec)

describe(@"STDispatchQueue", ^{
    describe(@"+queues", ^{
        context(@"with no instantiated queues", ^{
            it(@"should be empty", ^{
                STDispatchQueue.queues should be_empty;
            });
        });

        context(@"with an instantiated queue", ^{
            __block AsyncThing *thing;

            beforeEach(^{
                // Instantiates a queue in the initializer
                thing = [[AsyncThing alloc] init];
            });

            it(@"should contain the queue", ^{
                STDispatchQueue.queues should contain(thing.queue);
            });
        });
    });
});

SPEC_END
