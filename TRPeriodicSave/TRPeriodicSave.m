#import "JRSwizzle.h"
#import "TRPeriodicSave.h"

@implementation NSObject (TRPeriodicSave)

// TrackRecord calls [TimeTrackerController toggleTimer:(id)arg] when starting or stopping a timer.
- (void)TRPeriodicSave_toggleTimer:(id)arg1
{
    [[TRPeriodicSave sharedInstance] toggleSaveTimer];
    
    for (NSObject *timer in [[self timerArrayController] selectedObjects]) {
        if ([[timer timeSpent] isEqualToNumber:[NSNumber numberWithInt:0]])
            [timer setDate:[NSDate date]];
    }
    
    [self TRPeriodicSave_toggleTimer:arg1];
}

@end

@implementation TRPeriodicSave

@synthesize saveTimer;

+ (void)load
{
    [NSClassFromString(@"TimeTrackerController") jr_swizzleMethod:@selector(toggleTimer:) withMethod:@selector(TRPeriodicSave_toggleTimer:) error:NULL];
}

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
        NSLog(@"TRPeriodicSave: Stopping periodic save timer.");
        
        [self.saveTimer invalidate];
        self.saveTimer = nil;
    } else {
        NSLog(@"TRPeriodicSave: Starting periodic save timer.");
        
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