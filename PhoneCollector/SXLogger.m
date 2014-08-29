//
//  SXLogger.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/29/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXLogger.h"
#import "GAIDictionaryBuilder.h"

@implementation SXLogger


+ (void)logShowAds{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"show_ads"  // Event action (required)
                                                           label:@"ads"          // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)logCloseAds{

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"close_ads"  // Event action (required)
                                                           label:@"ads"          // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)logPlayTime:(NSNumber*)playTime{
    //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
//    [tracker send:[GAIDictionaryBuilder createTimingWithCategory:@"game time"    // Timing category (required)
//                                                        interval:playTime   // Timing interval (required)
//                                                            name:@"play time" // Timing name
//                                                           label:nil] build];    // Timing label
//    [[tracker send:[GAIDictionaryBuilder createTimingWithCategory:@"asdf"
//                                                         interval:playTime
//                                                             name:@"asdf"
//                                                            label:nil]]build];
}

+ (void)logRestartGame{

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"game_action"     // Event category (required)
                                                          action:@"restart_game"  // Event action (required)
                                                           label:@"game"          // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)logEnterGame{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"game_action"     // Event category (required)
                                                          action:@"enter_game"  // Event action (required)
                                                           label:@"game"          // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)logScore:(int)score{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSString* action = [NSString stringWithFormat:@"score_%d",score];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"game_action"     // Event category (required)
                                                          action:action // Event action (required)
                                                           label:@"score"        // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)logClickRemoveAds{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"click_remove_ads"  // Event action (required)
                                                           label:@"ads"          // Event label
                                                           value:nil] build]];    // Event value
}

+ (void)logSuccessRemoveAds{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"game_action"     // Event category (required)
                                                          action:@"success_remove_ads"  // Event action (required)
                                                           label:@"ads"          // Event label
                                                           value:nil] build]];    // Event value
}
@end
