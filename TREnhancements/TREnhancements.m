#import "TREnhancements.h"
#import "TRPeriodicSave.h"
#import "JRSwizzle.h"

@implementation NSObject (TREnhancements)

// TrackRecord calls [TimeTrackerController toggleTimer:(id)arg] when starting or stopping a timer.
- (void)TREnhancements_toggleTimer:(id)arg1
{
    // Set the timer's date to today's date if no time has been logged.
    for (NSObject *timer in [[self timerArrayController] selectedObjects]) {
        if ([[timer timeSpent] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            NSLog(@"TREnhancements: Timer \"%@\" has no time logged. Resetting the date to today.", [timer desc]);
            
            [timer setDate:[NSDate date]];
        }
    }
    
    [[TRPeriodicSave sharedInstance] toggleSaveTimer];    
    [self TREnhancements_toggleTimer:arg1];
}

@end

@implementation TREnhancements

+ (void)load
{
    NSLog(@"Loading TREnhancements...");
    
    [NSClassFromString(@"TimeTrackerController") jr_swizzleMethod:@selector(toggleTimer:) withMethod:@selector(TREnhancements_toggleTimer:) error:NULL];
}

@end