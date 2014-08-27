//
//  SXGamePauseView.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGamePauseView.h"

@implementation SXGamePauseView

- (instancetype)init {
    if (self = [super init]) {
        CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, 300, 480), nil);
        self.path = path;
        CGPathRelease(path);
        self.name = @"gamepauseview";
        self.lineWidth = 3;
        self.strokeColor = [SKColor orangeColor];
        self.fillColor = [SKColor orangeColor];
    }
    return self;
}

- (void)initUI
{
    //background view
 //   SKSpriteNode* backgroundNode= [[SKSpriteNode alloc]initWithImageNamed:@"PauseBackground"];
//    [self addChild:backgroundNode];
    
    //restart
    
    //resume
    
    //home
    
    //voice
}
@end
