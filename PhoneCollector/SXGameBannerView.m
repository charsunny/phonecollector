//
//  SXGameBannerView.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/28/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameBannerView.h"
#import "GADBannerView.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>


#define UNIT_ID @"ca-app-pub-4119830468405392/4271828063"

@interface SXGameBannerView()<GADBannerViewDelegate>

@end

@implementation SXGameBannerView
{
    GADBannerView* bannerView;
    BOOL isReceived;
}

+ (instancetype)getInstance {
    static SXGameBannerView* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SXGameBannerView alloc] initWithFrame:CGRectMake(5, 130, 315, 280)];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)presentBannerView
{
    if ([self isUnlockRemoveAds]) {
        return;
    }
    
    UIButton* closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 31, 20, 20)];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAds:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    if (isReceived && arc4random() % 10 < 8) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

- (BOOL)isUnlockRemoveAds {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"removeAds"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"removeAds"];
    }
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"removeAds"] boolValue];
}

-(void)preLoadAds
{
    bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
    bannerView.adUnitID = UNIT_ID;
    bannerView.rootViewController = [[[[UIApplication sharedApplication] delegate]window]rootViewController];
    bannerView.frame = CGRectMake(0, 30, bannerView.frame.size.width, bannerView.frame.size.height);
    [self addSubview:bannerView];
    bannerView.layer.borderColor = [UIColor whiteColor].CGColor;
    bannerView.layer.cornerRadius = 10;
    bannerView.layer.borderWidth = 0.5f;
    bannerView.delegate = self;
    [bannerView loadRequest:[GADRequest request]];
}

-(void)closeAds:(UIButton*)button
{
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)adViewDidReceiveAd:(GADBannerView *)view
{
    isReceived = YES;
}

@end
