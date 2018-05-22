//
//  ScreenProtector.m
//  Sample
//
//  Created by Mihui on 16/5/6.
//
//

#import "ScreenProtector.h"

@implementation ScreenProtector

@synthesize bgColor = _bgColor;
static ScreenProtector *_protector = nil;

- (void)pluginInitialize{
    PRINT(@"### pluginInitialize ###");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    _protector = self;
    _bgColor = nil;
}

- (UIView*) protect{
    UIView *maskView = nil;
    if([ScreenProtector isOSVersion:8] && [self bgColor] == nil){
        // iOS 8 and above
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        maskView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        maskView.frame = [[self webView] frame];
    }
    else{
        _bgColor = [UIColor colorWithRed:0.161 green:0.584 blue:0.980 alpha:1.00];
        maskView = [[UIView alloc] initWithFrame: [[self webView] frame]];
        [maskView setBackgroundColor:_bgColor];
    }
    [maskView setTag:VIEW_TAG];
    [[self webView] addSubview:maskView];
    return maskView;
}

-(void) onActive:(UIApplication *)application{
    PRINT(@"### onActive ###");
    [self.commandDelegate evalJs:@"cordova.fireWindowEvent('protector.active');"];
    [[[self webView] viewWithTag:VIEW_TAG] removeFromSuperview];
}

-(void) onPause:(UIApplication *)application{
    PRINT(@"### onPause ###");
    [self.commandDelegate evalJs:@"cordova.fireWindowEvent('protector.pause');"];
    [self protect];
}

+ (BOOL) isOSVersion:(int) version{
    if([[[UIDevice currentDevice] systemVersion] intValue] >= version){
        return YES;
    }
    return NO;
}

+ (ScreenProtector*) getInstance{
    return _protector;
}

@end
