//
//  SXLogger.h
//  PhoneCollector
//
//  Created by Lanston Peng on 8/29/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"

@interface SXLogger : NSObject

+ (void)logShowAds;

+ (void)logCloseAds;

+ (void)logPlayTime:(NSNumber*)playTime;

+ (void)logRestartGame;

+ (void)logEnterGame;

+ (void)logScore:(int)score;

+ (void)logClickRemoveAds;

+ (void)logSuccessRemoveAds;
@end
