#import <Foundation/Foundation.h>

#define dispatch_queue_create proxy_dispatch_queue_create
extern dispatch_queue_t (*proxy_dispatch_queue_create)(const char *, dispatch_queue_attr_t);

#define dispatch_async proxy_dispatch_async
extern void (*proxy_dispatch_async)(dispatch_queue_t, dispatch_block_t);
