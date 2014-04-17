#import <Foundation/Foundation.h>

DISPATCH_RETURNS_RETAINED
dispatch_group_t (*proxy_dispatch_group_create)(void) = dispatch_group_create;

void (*proxy_dispatch_group_async)(dispatch_group_t, dispatch_queue_t, dispatch_block_t) = dispatch_group_async;
