//
//  SXMyScene.m
//  PhoneCollector
//
//  Created by Sun Xi on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameScene.h"
#import "SXGamePauseView.h"

@interface SXGameScene()

@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUp;

@property (strong, nonatomic) UISwipeGestureRecognizer* swipeDown;

@property (strong, nonatomic) SKShapeNode* surfaceNode;

@property (assign,nonatomic) int tickCount;

@property (assign,nonatomic) CFTimeInterval timeInterval;

@property (assign) CFTimeInterval updateInterval;

@property (assign) float animationTime;
//Game Control View
@property (strong,nonatomic)SKShapeNode* pauseBtnNode;

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
        _surfaceNode.name = @"surface";
        [self addChild:_surfaceNode];
        
        _animationTime = 1;
        _updateInterval = 1;
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
    [self initGameControlView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    NSLog(@"%@",node);
    if ([node.name isEqualToString:@"pauseNode"]) {
        self.scene.view.paused = YES;
        //present pause view
        SXGamePauseView* pauseView = [SXGamePauseView new];
        pauseView.position = CGPointMake(self.size.width/2, self.size.height/2);
        [_surfaceNode addChild:pauseView];
        [pauseView initUI];
    }
}

- (void)initGameControlView
{
    _pauseBtnNode= [SKShapeNode node];
    _pauseBtnNode.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 20, 20) cornerRadius:4].CGPath;
    _pauseBtnNode.strokeColor = [SKColor redColor];
    _pauseBtnNode.fillColor = [SKColor blueColor];
    _pauseBtnNode.name = @"pauseNode";
    [_surfaceNode addChild:_pauseBtnNode];
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
//    UIBezierPath*    aPath = [UIBezierPath bezierPath];
//    [aPath moveToPoint:CGPointMake(self.size.width/2, self.size.height - 100)];
//    [aPath closePath];
//    CGPathRef bezierPath = aPath.CGPath;
//    [moveNode runAction:[SKAction followPath:bezierPath duration:0.3]];
    [moveNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360 duration:1.0f]] completion:nil];
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
    
    [moveNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360 duration:1.0f]] completion:nil];
    [moveNode runAction:[SKAction moveTo:CGPointMake(self.size.width/2, 100) duration:0.3f] completion:^{
        [moveNode removeFromParent];
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (_timeInterval == 0) {
        _timeInterval = currentTime;
        return;
    }
    if (currentTime - _timeInterval > _updateInterval) {
        _timeInterval = currentTime;
        _tickCount++;
//        _updateInterval = 0.1f + 0.3f/log2(_tickCount+2);
//        _animationTime = 0.6f + 0.4f/log2(_tickCount+2);
        //NSLog(@"_updateInterval:%f, _animationTime:%f", _updateInterval, _animationTime);
        SKSpriteNode* iphoneNode = [SKSpriteNode spriteNodeWithImageNamed:@"iphone"];
        [iphoneNode setScale:0.5f];
        iphoneNode.position = CGPointMake(self.size.width + 32, self.size.height/2);
        [self addChild:iphoneNode];
        [iphoneNode runAction:[SKAction moveTo:CGPointMake(-32, self.size.height/2) duration:_animationTime] completion:^{
            [iphoneNode removeFromParent];
        }];
    }
}

@end
