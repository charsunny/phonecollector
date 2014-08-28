//
//  SXMyScene.m
//  PhoneCollector
//
//  Created by Sun Xi on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameScene.h"
#import "SXGamePauseView.h"
#import "SXGameMenuScene.h"
#import "SXGameResultScene.h"

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
@property (strong,nonatomic)SKSpriteNode* pauseBtnNode;

@property (strong,nonatomic)SXGamePauseView* pauseView;

@property (nonatomic)int firstNumber;

@property (nonatomic)BOOL gamePaused;

@end

@implementation SXGameScene
{
    NSMutableArray* actionNodeArr;
}

- (void)setScore:(int)score
{
    _score = score;
    SKLabelNode* label = (SKLabelNode*)[_surfaceNode childNodeWithName:@"score"];
    [label setText:[NSString stringWithFormat:@"%d", _score]];
    SKAction* sequenceAction = [SKAction sequence:@[[SKAction scaleTo:1.2 duration:0.15],[SKAction scaleTo:1 duration:0.1]]];
    [label runAction:sequenceAction];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        _animationTime = 1.0;
        _updateInterval = 0.5;
        self.score = 0;
        
        _firstNumber = 0;
        
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.backgroundColor = UIColorFromRGB(0xFFAB21);
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
        
        SKSpriteNode* dustbin = [[SKSpriteNode alloc]initWithImageNamed:@"Dustbin"];
        dustbin.name = @"dustbin";
        //dustbin.size
        dustbin.position = CGPointMake(self.size.width / 2,30);
        [_surfaceNode addChild:dustbin];
        
        actionNodeArr = [[NSMutableArray alloc]init];
    }
    return self;
}

- (UIView*)createGuideView {
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel* upGuideLabel = [UILabel new];
    [upGuideLabel setText:@"Swipe up to collect an Iphone 📱"];
    [upGuideLabel setFont:[UIFont fontWithName:@"Chalkduster" size:14]];
    [upGuideLabel sizeToFit];
    upGuideLabel.center = CGPointMake(160, 80);
    [bgView addSubview:upGuideLabel];
    
    UILabel* downGuideLabel = [UILabel new];
    [downGuideLabel setText:@"Swipe down to abandon other phone"];
    [downGuideLabel setFont:[UIFont fontWithName:@"Chalkduster" size:14]];
    [downGuideLabel sizeToFit];
    downGuideLabel.center = CGPointMake(160, 240);
    [bgView addSubview:downGuideLabel];

    UIButton* startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [startButton setTitle:@"Tap to begin" forState:UIControlStateNormal];
    [startButton.titleLabel setFont:[UIFont fontWithName:@"Chalkduster" size:24]];
    [startButton sizeToFit];
    [startButton addTarget:self action:@selector(onStartGame:) forControlEvents:UIControlEventTouchUpInside];
    startButton.center = CGPointMake(160, 160);
    [bgView addSubview:startButton];
    
    return bgView;
}

- (void)didMoveToView:(SKView *)view {
    _gamePaused = YES;
    _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeUp:)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:_swipeUp];
    _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeDown:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:_swipeDown];
    UIView* guideView = [self createGuideView];
    guideView.center = CGPointMake(self.size.width/2, self.size.height/2);
    [self.view addSubview:guideView];

}

- (void)onStartGame:(UIButton*)sender {
    [self initGameControlView];
    [[sender superview] removeFromSuperview];
    _gamePaused = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode* node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"pauseNode"]) {
        //self.scene.view.paused = !self.scene.view.paused;
        
        _gamePaused = !_gamePaused;
        if (_gamePaused) {
            [actionNodeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ((SKSpriteNode*)actionNodeArr[idx]).paused = YES;
            }];
            _pauseView = [[SXGamePauseView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self.view addSubview:_pauseView];
        }
        else
        {
            [actionNodeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ((SKSpriteNode*)actionNodeArr[idx]).paused = NO;
            }];
            [_pauseView removeFromSuperview];
        }
        
    }
}

- (void)initGameControlView
{
    _pauseBtnNode = [[SKSpriteNode alloc]initWithImageNamed:@"Pause"];
    _pauseBtnNode.anchorPoint = CGPointMake(0, 0);
    _pauseBtnNode.size = CGSizeMake(25, 25);
    _pauseBtnNode.position = CGPointMake(10 , 10);
    _pauseBtnNode.name = @"pauseNode";
    [_surfaceNode addChild:_pauseBtnNode];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlePauseViewCmd:) name:@"cmd" object:nil];
    
}
- (void)handlePauseViewCmd:(NSNotification*)notificator
{
    NSDictionary* dic = notificator.userInfo;
    NSString* cmd = dic[@"cmd"];
    if ([cmd isEqualToString:@"restart"]) {
        self.score = 0;
        [actionNodeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [((SKSpriteNode*)actionNodeArr[idx])removeFromParent];
        }];
        [actionNodeArr removeAllObjects];
        [_pauseView removeFromSuperview];
        _gamePaused = NO;
    }
    else if ([cmd isEqualToString:@"resume"]){
        [actionNodeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ((SKSpriteNode*)actionNodeArr[idx]).paused = NO;
        }];
        _gamePaused = NO;
        [_pauseView removeFromSuperview];
    }
    else if ([cmd isEqualToString:@"home"])
    {
        [_pauseView removeFromSuperview];
        SKTransition* transition = [SKTransition doorsCloseVerticalWithDuration:0.6];
        
        SKScene * scene = [SXGameMenuScene sceneWithSize:self.frame.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.scene.view presentScene:scene transition:transition];
    }
}


- (void)willMoveFromView:(SKView *)view {
    [view removeGestureRecognizer:_swipeUp];
    [view removeGestureRecognizer:_swipeDown];
}

- (void)onSwipeUp:(UISwipeGestureRecognizer*)recognizer {
    if ([self children].count <= 1 || _gamePaused) {
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
            self.score++;
        } else {
            [self showGameResult];
        }
    }];
    
}

- (void)onSwipeDown:(UISwipeGestureRecognizer*)recognizer {
    if ([self children].count <= 1 || _gamePaused) {
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
        SKAction* sequenceAction = [SKAction sequence:@[[SKAction scaleTo:1.2 duration:0.15],[SKAction scaleTo:1 duration:0.1]]];
        [[_surfaceNode childNodeWithName:@"dustbin"] runAction:sequenceAction];
    }];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (_gamePaused) {
        return;
    }
    _firstNumber++;
    NSLog(@"%d",_firstNumber);
    if ( _firstNumber  > 15)
    {
        NSLog(@"inside");
        _firstNumber = 0;
        
        SKSpriteNode* phoneNode = [self createPhoneNode:rand()%2];
        [phoneNode setScale:0.5f];
        phoneNode.position = CGPointMake(self.size.width + 32, self.size.height/2);
        [self addChild:phoneNode];
        [actionNodeArr addObject:phoneNode];
        [phoneNode runAction:[SKAction moveTo:CGPointMake(-32, self.size.height/2) duration:_animationTime] completion:^{
            NSLog(@"animation finish");
            [phoneNode removeFromParent];
            [self showGameResult];
            [actionNodeArr removeObject:phoneNode];
        }];
    }
}


//-(void)update:(CFTimeInterval)currentTime {
//    /* Called before each frame is rendered */
//    //NSLog(@"%f",currentTime);
//    if (_timeInterval == 0) {
//        _timeInterval = currentTime;
//        return;
//    }
//    if (currentTime - _timeInterval > _updateInterval) {
//        NSLog(@"%f",_updateInterval);
//        _timeInterval = currentTime;
//        _tickCount++;
//        if (_tickCount > 40) {
//            _tickCount = 40;
//        }
//        _updateInterval = 0.5 - 0.05*(_tickCount/10);
//        SKSpriteNode* phoneNode = [self createPhoneNode:rand()%2];
//        [phoneNode setScale:0.5f];
//        phoneNode.position = CGPointMake(self.size.width + 32, self.size.height/2);
//        [self addChild:phoneNode];
//        [phoneNode runAction:[SKAction moveTo:CGPointMake(-32, self.size.height/2) duration:_animationTime] completion:^{
//            NSLog(@"animation finish");
//            [phoneNode removeFromParent];
//            [self showGameResult];
//        }];
//    }
//}

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
    SXGameResultScene* scene = [SXGameResultScene sceneWithSize:self.frame.size];
    scene.score = self.score;
    [self.view presentScene:scene transition:[SKTransition doorsOpenVerticalWithDuration:0.3f]];
}

@end
