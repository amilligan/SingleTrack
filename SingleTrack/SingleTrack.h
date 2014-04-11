#import <Foundation/Foundation.h>

#define dispatch_queue_create dispatch_queue_create_proxy
extern dispatch_queue_t (*dispatch_queue_create_proxy)(const char *, dispatch_queue_attr_t);

