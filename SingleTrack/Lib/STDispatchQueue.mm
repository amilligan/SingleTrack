#import <Foundation/Foundation.h>

DISPATCH_RETURNS_RETAINED
dispatch_queue_t (*proxy_dispatch_queue_create)(const char *, dispatch_queue_attr_t) = dispatch_queue_create;

void (*proxy_dispatch_async)(dispatch_queue_t, dispatch_block_t) = dispatch_async;
