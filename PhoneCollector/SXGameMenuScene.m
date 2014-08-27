//
//  SXGameMenuScene.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameMenuScene.h"
#import "SXGameScene.h"


#define TRANSITION_TIME_INTERVAL 0.3

@interface SXGameMenuScene()

@property (strong,nonatomic)SKTransition* sceneTransition;

@property (strong,nonatomic)UIButton* startBtn;

@property (strong,nonatomic)UIButton* gameCenterBtn;

@property (strong,nonatomic)UIButton* settingBtn;

@property (strong,nonatomic)UIView* gameLogoView;
@end

@implementation SXGameMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [self initUI];
}

-(void)initUI
{
    CGRect f = self.frame;
    _startBtn = [[UIButton alloc]initWithFrame:CGRectMake(f.size.width / 2 - 50 , f.size.height / 2 - 30, 100, 60)];
    [_startBtn setTitle:@"START" forState:UIControlStateNormal];
    _startBtn.backgroundColor = [UIColor blueColor];
    [_startBtn addTarget:self action:@selector(transferToMainGameScene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    
    _gameCenterBtn = [[UIButton alloc]initWithFrame:CGRectMake(f.size.width / 3 - 40 , f.size.height - 20 , 80, 20)];
    [_gameCenterBtn setTitle:@"Game Center" forState:UIControlStateNormal];
    _gameCenterBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _gameCenterBtn.backgroundColor = [UIColor blueColor];
    [_gameCenterBtn addTarget:self action:@selector(handleGameCenterTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gameCenterBtn];
    
    _settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(f.size.width / 3 * 2 - 40 , f.size.height - 20 , 80, 20)];
    [_settingBtn setTitle:@"Setting" forState:UIControlStateNormal];
    _settingBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _settingBtn.backgroundColor = [UIColor blueColor];
    [_settingBtn addTarget:self action:@selector(handleSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingBtn];
}

- (void)handleSetting:(id)sender
{
    
}

- (void)handleGameCenterTap:(id)sender
{
    
}

- (void)transferToMainGameScene:(id)sender
{
    _sceneTransition = [SKTransition doorsOpenVerticalWithDuration:TRANSITION_TIME_INTERVAL];
    
    SKScene * scene = [SXGameScene sceneWithSize:self.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.scene.view presentScene:scene transition:_sceneTransition];
    
    [self removeUIKitView];
}

- (void)removeUIKitView
{
    [_startBtn removeFromSuperview];
    [_gameCenterBtn removeFromSuperview];
    [_settingBtn removeFromSuperview];
}

@end
