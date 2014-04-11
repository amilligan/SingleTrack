#import <Foundation/Foundation.h>

@interface AsyncThing : NSObject

@property (nonatomic, strong, readonly) dispatch_queue_t queue;
@property (nonatomic, assign, readonly) NSInteger value;

- (void)setValueAsync:(NSInteger)value;

@end
