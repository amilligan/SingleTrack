#import <Foundation/Foundation.h>

DISPATCH_RETURNS_RETAINED
dispatch_queue_t (*dispatch_queue_create_proxy)(const char *, dispatch_queue_attr_t) = dispatch_queue_create;
