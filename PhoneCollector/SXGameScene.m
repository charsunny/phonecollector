//
//  SXMyScene.m
//  PhoneCollector
//
//  Created by Sun Xi on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameScene.h"

@interface SXGameScene()

@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUp;

@property (strong, nonatomic) UISwipeGestureRecognizer* swipeDown;

@property (strong, nonatomic) SKShapeNode* surfaceNode;

@property (assign) int tickCount;

@property (assign) CFTimeInterval timeInterval;

@end

@implementation SXGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _surfaceNode = [SKShapeNode node];
        CGPathRef path = CGPathCreateWithRect(self.frame, nil);
        _surfaceNode.path = path;
        CGPathRelease(path);
        _surfaceNode.antialiased = NO;
        _surfaceNode.lineWidth = 1.0;
        _surfaceNode.strokeColor = [SKColor orangeColor];
        [self addChild:_surfaceNode];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeUp:)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:_swipeUp];
    _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeDown:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:_swipeDown];
}

- (void)willMoveFromView:(SKView *)view {
    [view removeGestureRecognizer:_swipeUp];
    [view removeGestureRecognizer:_swipeDown];
}

- (void)onSwipeUp:(UISwipeGestureRecognizer*)recognizer {
    if ([self children].count <= 1) {
        return;
    }
    SKNode* node = [self children][1];
    [node removeAllActions];
    SKNode* moveNode = [node copy];
    [_surfaceNode addChild:moveNode];
    [node removeFromParent];
    [moveNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360 duration:0.2f]] completion:nil];
    [moveNode runAction:[SKAction moveTo:CGPointMake(self.size.width/2, self.size.height - 100) duration:0.3f] completion:^{
        [moveNode removeFromParent];
    }];
    
}

- (void)onSwipeDown:(UISwipeGestureRecognizer*)recognizer {
    if ([self children].count <= 1) {
        return;
    }
    SKNode* node = [self children][1];
    [node removeAllActions];
    SKNode* moveNode = [node copy];
    [_surfaceNode addChild:moveNode];
    [node removeFromParent];
    
    [moveNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360 duration:0.2f]] completion:nil];
    [moveNode runAction:[SKAction moveTo:CGPointMake(self.size.width/2, 100) duration:0.3f] completion:^{
        [moveNode removeFromParent];
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (currentTime - _timeInterval > .5) {
        _timeInterval = currentTime;
        _tickCount++;
        SKSpriteNode* iphoneNode = [SKSpriteNode spriteNodeWithImageNamed:@"iphone"];
        [iphoneNode setScale:0.5f];
        iphoneNode.position = CGPointMake(self.size.width + 32, self.size.height/2);
        [self addChild:iphoneNode];
        [iphoneNode runAction:[SKAction moveTo:CGPointMake(-32, self.size.height/2) duration:2] completion:^{
            [iphoneNode removeFromParent];
        }];
    }
}

@end
