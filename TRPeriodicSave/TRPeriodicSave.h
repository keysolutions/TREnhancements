#import <Cocoa/Cocoa.h>

@interface TRPeriodicSave : NSObject

@property (nonatomic) NSTimer *saveTimer;

+ (id)sharedInstance;
- (void)toggleSaveTimer;
- (void)performSave:(NSTimer *)aTimer;

@end