#import "STDispatchGroup.h"
#import "STDispatch.h"
#import "AsyncThing.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(STDispatchGroupSpec)

describe(@"STDispatchGroup", ^{
    __block STDispatchGroup *group;

    beforeEach(^{
        group = [[STDispatchGroup alloc] init];
    });

    describe(@"+beforeEach", ^{
        __block AsyncThing *thing;

        subjectAction(^{ [[STDispatchGroup class] performSelector:@selector(beforeEach)]; });

        beforeEach(^{
            thing = [[AsyncThing alloc] init];
            STDispatchGroup.groups should_not be_empty;
        });

        it(@"should clear the list of groups", ^{
            STDispatchGroup.groups should be_empty;
        });
    });

    describe(@"-enqueue", ^{
        __block NSInteger value;
        NSInteger newValue = 7;
        id block = ^{ value = newValue; };

        subjectAction(^{ [group enqueue:block]; });

        beforeEach(^{
            value = 0;
        });

        it(@"should add the block to the list of blocks for the group", ^{
            group.tasks should contain(block);
        });
    });

    describe(@"dispatch_group_create", ^{
        __block AsyncThing *thing;

        // AsyncThing instantiates a group in the initializer
        subjectAction(^{ thing = [[AsyncThing alloc] init]; });

        it(@"should add the group to the list of instantiated groups", ^{
            STDispatchGroup.groups should contain(thing.group);
        });
    });

    describe(@"dispatch_group_async", ^{
        __block AsyncThing *thing;
        NSInteger newValue = 9;

        subjectAction(^{ [thing setValueGroupAsync:newValue]; });

        beforeEach(^{
            STDispatch.behavior = STDispatchBehaviorManual;
            thing = [[AsyncThing alloc] init];
        });

        it(@"should enqueue the block on the queue", ^{
            [(id)thing.queue tasks] should_not be_empty;
        });

        it(@"should add the block to the group", ^{
            [(id)thing.group tasks] should_not be_empty;
        });
    });
});

SPEC_END
