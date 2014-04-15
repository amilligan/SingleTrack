#import "ViewController.h"
#import "AsyncThing.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) dispatch_queue_t queue;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.queue = dispatch_queue_create("thing things", DISPATCH_QUEUE_CONCURRENT);
    [self displayValue];
}

- (IBAction)didTapDoIt:(id)sender {
    dispatch_async(self.queue, ^{
        self.value = self.value + 10;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayValue];
        });
    });
}

- (void)displayValue {
    self.valueLabel.text = [NSString stringWithFormat:@"%d", self.value];
}

@end
