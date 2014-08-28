//
//  SXGameBannerView.h
//  PhoneCollector
//
//  Created by Lanston Peng on 8/28/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXGameBannerView : UIView

+ (instancetype)getInstance;

-(void)presentBannerView;

-(void)preLoadAds;

@end
