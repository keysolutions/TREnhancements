#import "TRPeriodicSave.h"

@implementation TRPeriodicSave

@synthesize saveTimer;

+ (id)sharedInstance
{
    static TRPeriodicSave *sharedInstance = NULL;
    
    if (sharedInstance == NULL)
        sharedInstance = [[TRPeriodicSave alloc] init];
    
    return sharedInstance;
}

- (void)toggleSaveTimer
{
    if (self.saveTimer) {
        NSLog(@"TREnhancements: Stopping periodic save timer.");
        
        [self.saveTimer invalidate];
        self.saveTimer = nil;
    } else {
        NSLog(@"TREnhancements: Starting periodic save timer.");
        
        self.saveTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(performSave:) userInfo:nil repeats:YES];
    }
}

- (void)performSave:(NSTimer *)aTimer
{
    // TrackRecord's [AppDelegate saveAction:(id)arg] saves the current timer state. The
    // AppDelegate instance is handily found as the NSApplication delegate.
    [[[NSApplication sharedApplication] delegate] saveAction:self];
}

@end