#import <Foundation/Foundation.h>

DISPATCH_RETURNS_RETAINED
dispatch_queue_t (*proxy_dispatch_queue_create)(const char *, dispatch_queue_attr_t) = dispatch_queue_create;

static dispatch_queue_t dispatch_get_main_queue_f(void) {
    return (__bridge dispatch_queue_t)&_dispatch_main_q;
}
dispatch_queue_t (*proxy_dispatch_get_main_queue)(void) = dispatch_get_main_queue_f;

void (*proxy_dispatch_async)(dispatch_queue_t, dispatch_block_t) = dispatch_async;
