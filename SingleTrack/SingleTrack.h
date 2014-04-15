#import <Foundation/Foundation.h>

#define dispatch_queue_create proxy_dispatch_queue_create
extern dispatch_queue_t (*proxy_dispatch_queue_create)(const char *, dispatch_queue_attr_t);

#undef dispatch_get_main_queue
#define dispatch_get_main_queue proxy_dispatch_get_main_queue
extern dispatch_queue_t (*proxy_dispatch_get_main_queue)();

#define dispatch_async proxy_dispatch_async
extern void (*proxy_dispatch_async)(dispatch_queue_t, dispatch_block_t);

#define dispatch_group_create proxy_dispatch_group_create
extern dispatch_group_t (*proxy_dispatch_group_create)(void);

#define dispatch_group_async proxy_dispatch_group_async
extern void (*proxy_dispatch_group_async)(dispatch_group_t, dispatch_queue_t, dispatch_block_t);
