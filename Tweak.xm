#import <UIKit/UIKit.h>
#import <Foundation/NSUserDefaults+Private.h>

#define PKG_ID "com.darwindev.no-screenshot-preview"

@interface SSScreenshotsWindowRootViewController : UIViewController
@end

static BOOL _kNSPEnabled = NO;
static SSScreenshotsWindowRootViewController *_rootViewController = nil;

%hook SSScreenshotsWindowRootViewController
- (void)viewDidLoad {
    %orig;
    [self.view setHidden:_kNSPEnabled];
    _rootViewController = self;
}
%end

%hook SSScreenCapturer
+ (void)playScreenshotSound {
    if (!_kNSPEnabled)
        %orig;
}
%end

static void LoadPrefs(CFNotificationCenterRef center, 
                      void *observer, 
                      CFStringRef name, 
                      const void *object, 
                      CFDictionaryRef userInfo)
{
    _kNSPEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:@PKG_ID] boolValue];
    [_rootViewController.view setHidden:_kNSPEnabled];
}

%ctor 
{
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)LoadPrefs,
        CFSTR("com.darwindev.no-screenshot-preview.defaults-changed"),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce
    );

    LoadPrefs(NULL, NULL, NULL, NULL, NULL);
}