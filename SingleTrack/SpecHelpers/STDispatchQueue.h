#import <Foundation/Foundation.h>
#import "STDispatchQueue.h"

@interface STDispatchQueue : NSObject
@end

@interface STDispatchQueue (Collections)
+ (NSArray *)queues;
@end
