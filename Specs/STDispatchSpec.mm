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
});

SPEC_END
