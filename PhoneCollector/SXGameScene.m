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
#import "SXGameBannerView.h"
#import "SXLogger.h"

@interface SXGameScene()<SXGamePauseViewDelegate>
{
    NSMutableArray* actionNodeArr;
}

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

@property (nonatomic) int colorScheme;

@end

@implementation SXGameScene

- (void)setScore:(int)score
{
    _score = score;
    SKLabelNode* label = (SKLabelNode*)[_surfaceNode childNodeWithName:@"score"];
    [label setText:[NSString stringWithFormat:@"%d", _score]];
    SKAction* sequenceAction = [SKAction sequence:@[[SKAction scaleTo:1.2 duration:0.15],[SKAction scaleTo:1 duration:0.1]]];
    [label runAction:sequenceAction];
    
    SKSpriteNode* present = (SKSpriteNode*)[_surfaceNode childNodeWithName:@"present"];
    [present runAction:sequenceAction];
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        _animationTime = 1.0;
        _updateInterval = 0.5;
        self.score = 0;
        _firstNumber = 0;
        srand((unsigned int)time(NULL));
        _colorScheme = rand()%2;
        
        [self initGameControlView];
        
        actionNodeArr = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterBackground:) name:@"resignactive" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground:) name:@"becomeactive" object:nil];
    }
    return self;
}


- (void)initGameControlView
{
    _surfaceNode = [SKShapeNode node];
    CGPathRef path = CGPathCreateWithRect(self.frame, nil);
    _surfaceNode.path = path;
    CGPathRelease(path);
    _surfaceNode.antialiased = NO;
    _surfaceNode.lineWidth = 0;
    _surfaceNode.fillColor = UIColorFromRGB(0xFF4E50);
    _surfaceNode.name = @"surface";
    [self addChild:_surfaceNode];
    
    float midWidth = 300;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        midWidth = 140;
    }
    
    SKSpriteNode* topSprite = [SKSpriteNode spriteNodeWithColor:UIColorFromRGB(_colorScheme?0x4DC9FD:0x333333) size:CGSizeMake(self.size.width, (self.size.height - midWidth)/2)];
    topSprite.position = CGPointMake(self.size.width/2, 3*self.size.height/4+midWidth/4);
    [_surfaceNode addChild:topSprite];
    
    SKSpriteNode* bottomSprite = [SKSpriteNode spriteNodeWithColor:UIColorFromRGB(_colorScheme?0x00CE61:0x333333) size:CGSizeMake(self.size.width, (self.size.height - midWidth)/2)];
    bottomSprite.position = CGPointMake(self.size.width/2, self.size.height/4 - midWidth/4);
    [_surfaceNode addChild:bottomSprite];

    
    SKSpriteNode* present = [[SKSpriteNode alloc]initWithImageNamed:@"Present"];
    present.name = @"present";
    present.position = CGPointMake(self.size.width / 2, self.size.height - 70);
    [_surfaceNode addChild:present];
    
    SKLabelNode* scoreLabel = [SKLabelNode node];
    [scoreLabel setText:[NSString stringWithFormat:@"%d", _score]];
    [scoreLabel setName:@"score"];
    [scoreLabel setFontName:GAME_FONT];
    [scoreLabel setFontSize:60];
    [scoreLabel setPosition:CGPointMake(self.size.width/2, self.size.height - 112)];
    [_surfaceNode addChild:scoreLabel];
    
    SKSpriteNode* dustbin = [[SKSpriteNode alloc]initWithImageNamed:@"Dustbin"];
    dustbin.name = @"dustbin";
    dustbin.position = CGPointMake(self.size.width / 2,60);
    [_surfaceNode addChild:dustbin];
    
    
    _pauseBtnNode = [[SKSpriteNode alloc]initWithImageNamed:@"Pause"];
    _pauseBtnNode.anchorPoint = CGPointMake(0, 0);
    _pauseBtnNode.size = CGSizeMake(25, 25);
    _pauseBtnNode.position = CGPointMake(10 , 10);
    _pauseBtnNode.name = @"pauseNode";
    [_pauseBtnNode setHidden:YES];
    [_surfaceNode addChild:_pauseBtnNode];
    
    [[SXGameBannerView getInstance]preLoadAds];
}

- (UIView*)createGuideView {
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel* upGuideLabel = [UILabel new];
    [upGuideLabel setText:NSLocalizedString(@"Swipe Up to Collect Gold Coin",@"xxx")];
    [upGuideLabel setFont:[UIFont fontWithName:GAME_FONT size:18]];
    [upGuideLabel setTextColor:_colorScheme?[UIColor darkTextColor]:[UIColor whiteColor]];
    [upGuideLabel sizeToFit];
    upGuideLabel.center = CGPointMake(160, 70);
    [bgView addSubview:upGuideLabel];
    
    UILabel* downGuideLabel = [UILabel new];
    [downGuideLabel setText:NSLocalizedString(@"Swipe Down to Throw Pirate Flag",@"xx")];
    [downGuideLabel setFont:[UIFont fontWithName:GAME_FONT size:18]];
    [downGuideLabel setTextColor:_colorScheme?[UIColor darkTextColor]:[UIColor whiteColor]];
    [downGuideLabel sizeToFit];
    downGuideLabel.center = CGPointMake(160, 250);
    [bgView addSubview:downGuideLabel];

    UIButton* startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [startButton setTitle:NSLocalizedString(@"Tap to start",@"xx") forState:UIControlStateNormal];
    [startButton.titleLabel setFont:[UIFont fontWithName:GAME_FONT size:30]];
    [startButton sizeToFit];
    [startButton addTarget:self action:@selector(onStartGame:) forControlEvents:UIControlEventTouchUpInside];
    startButton.center = CGPointMake(160, 160);
//    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
//        startButton.alpha = 0.1;
//    } completion:^(BOOL finished) {
//        startButton.alpha = 1.0;
//    }];
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
    guideView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self.view addSubview:guideView];

}

- (void)willMoveFromView:(SKView *)view {
    [view removeGestureRecognizer:_swipeUp];
    [view removeGestureRecognizer:_swipeDown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onStartGame:(UIButton*)sender {
    [[_surfaceNode childNodeWithName:@"pauseNode"] setHidden:NO];
    [_surfaceNode runAction:[SKAction playSoundFileNamed:@"buttonclick.mp3" waitForCompletion:NO]];
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
            self.paused = YES;
            [actionNodeArr enumerateObjectsUsingBlock:^(SKSpriteNode* obj, NSUInteger idx, BOOL *stop) {
                [obj removeAllActions];
            }];
            _pauseView = [[SXGamePauseView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _pauseView.delegate = self;
            [self.view addSubview:_pauseView];
        }
        else
        {
            [self handleResume:nil];
        }
    }
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
    [moveNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:360 duration:1.0f]] completion:nil];
    [moveNode runAction:[SKAction moveTo:CGPointMake(self.size.width/2, self.size.height - 100) duration:0.3f] completion:^{
        [moveNode removeFromParent];
        if ([moveNode.userData[@"type"] intValue] == 0) {
            self.score++;
        } else {
            [self showGameResult];
        }
    }];
    [moveNode runAction:[SKAction playSoundFileNamed:@"pop1a.mp3" waitForCompletion:NO] completion:nil];
    
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
    [moveNode runAction:[SKAction playSoundFileNamed:@"pop2b.mp3" waitForCompletion:NO] completion:nil];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (_gamePaused) {
        return;
    }
    _firstNumber++;
    if ( _firstNumber  > 15)
    {
        _firstNumber = 0;
        SKSpriteNode* phoneNode = [self createPhoneNode:rand()%2];
        phoneNode.size = CGSizeMake(phoneNode.size.width * 2, phoneNode.size.height * 2);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [phoneNode setScale:0.5f];
        }
        phoneNode.position = CGPointMake(self.size.width + 32, self.size.height/2);
        [self addChild:phoneNode];
        [actionNodeArr addObject:phoneNode];
        [phoneNode runAction:[SKAction moveTo:CGPointMake(-32, self.size.height/2) duration:_animationTime] completion:^{
            [phoneNode removeFromParent];
            [self showGameResult];
            [actionNodeArr removeObject:phoneNode];
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
    SXGameResultScene* scene = [SXGameResultScene sceneWithSize:self.frame.size];
    scene.score = self.score;
    [self.view presentScene:scene transition:[SKTransition doorsOpenVerticalWithDuration:0.3f]];
    [SXLogger logScore:self.score];
}

#pragma mark handle background events

- (void)onEnterBackground:(NSNotification*)notif {
    if (!_gamePaused) {
        _gamePaused = !_gamePaused;
        self.paused = YES;
        [actionNodeArr enumerateObjectsUsingBlock:^(SKSpriteNode* obj, NSUInteger idx, BOOL *stop) {
            [obj removeAllActions];
        }];
        _pauseView = [[SXGamePauseView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pauseView.delegate = self;
        [self.view addSubview:_pauseView];
    }
}

- (void)onEnterForeground:(NSNotification*)notif {
    
}

#pragma mark -- pasueview delegate -- 

- (void)handleRestart:(UIButton*)button {
    [self.view presentScene:[SXGameScene sceneWithSize:self.size] transition:[SKTransition flipVerticalWithDuration:0.3f]];
    [_pauseView removeFromSuperview];
}

- (void)handleResume:(UIButton*)button {
    [actionNodeArr enumerateObjectsUsingBlock:^(SKSpriteNode* node, NSUInteger idx, BOOL *stop) {
        float animationTime = _animationTime* (node.position.x + 32)/(self.size.width + 64);
        [node runAction:[SKAction moveTo:CGPointMake(-32, self.size.height/2) duration:animationTime] completion:^{
            [node removeFromParent];
            [self showGameResult];
            [actionNodeArr removeObject:node];
        }];
    }];
    _gamePaused = NO;
    self.paused = _gamePaused;
    [_pauseView removeFromSuperview];
    
}

@end
