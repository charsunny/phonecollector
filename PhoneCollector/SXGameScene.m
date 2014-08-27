//
//  SXMyScene.m
//  PhoneCollector
//
//  Created by Sun Xi on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameScene.h"
//#import "SXGamePauseView.h"

@interface SXGameScene()

@property (strong, nonatomic) UISwipeGestureRecognizer* swipeUp;

@property (strong, nonatomic) UISwipeGestureRecognizer* swipeDown;

@property (strong, nonatomic) SKShapeNode* surfaceNode;

@property (assign,nonatomic) int tickCount;

@property (assign,nonatomic) CFTimeInterval timeInterval;

@property (assign, nonatomic) CFTimeInterval updateInterval;

@property (assign, nonatomic) float animationTime;

@property (assign, nonatomic) int score;
//Game Control View
@property (strong,nonatomic)SKShapeNode* pauseBtnNode;

@end

@implementation SXGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        _animationTime = 1.0;
        _updateInterval = 0.5;
        _score = 0;
        
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
        
        SKLabelNode* scoreLabel = [SKLabelNode node];
        [scoreLabel setText:[NSString stringWithFormat:@"%d", _score]];
        [scoreLabel setName:@"score"];
        [scoreLabel setFontName:@"Chalkduster"];
        [scoreLabel setFontSize:40];
        [scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height - 60)];
        [_surfaceNode addChild:scoreLabel];
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
    if ([node.name isEqualToString:@"pauseNode"]) {
        self.scene.view.paused = !self.scene.view.paused;
        //present pause view
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
        if ([moveNode.userData[@"type"] intValue] == 0) {
            _score++;
            SKLabelNode* label = (SKLabelNode*)[_surfaceNode childNodeWithName:@"score"];
            [label setText:[NSString stringWithFormat:@"%d", _score]];
        } else {
            [self showGameResult];
        }
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
        if ([moveNode.userData[@"type"] intValue] == 0) {
            [self showGameResult];
        }
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
        if (_tickCount > 40) {
            _tickCount = 40;
        }
        _updateInterval = 0.5 - 0.05*(_tickCount/10);
        SKSpriteNode* phoneNode = [self createPhoneNode:rand()%2];
        [phoneNode setScale:0.5f];
        phoneNode.position = CGPointMake(self.size.width + 32, self.size.height/2);
        [self addChild:phoneNode];
        [phoneNode runAction:[SKAction moveTo:CGPointMake(-32, self.size.height/2) duration:_animationTime] completion:^{
            [phoneNode removeFromParent];
            [self showGameResult];
        }];
    }
}

- (SKSpriteNode*)createPhoneNode:(int)phonetype {
    NSString* phoneName = nil;
    switch (phonetype) {
        case 0:
            phoneName = @"iphone";
            break;
        case 1:
            phoneName = @"android";
            break;
        default:
            phoneName = @"iphone";
            break;
    }
    SKSpriteNode* spriteNode =  [SKSpriteNode spriteNodeWithImageNamed:phoneName];
    spriteNode.userData = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@(phonetype)}];
    return spriteNode;
}

- (void)showGameResult {
    NSLog(@"game over");
}

@end
