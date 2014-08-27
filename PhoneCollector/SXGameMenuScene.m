//
//  SXGameMenuScene.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameMenuScene.h"
#import "SXGameScene.h"


@interface SXGameMenuScene()

@property (strong,nonatomic)SKTransition* sceneTransition;

@property (strong,nonatomic)UIButton* startBtn;
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
}

- (void)transferToMainGameScene:(id)sender
{
    _sceneTransition = [SKTransition doorsOpenVerticalWithDuration:0.3];
    
    SKScene * scene = [SXGameScene sceneWithSize:self.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.scene.view presentScene:scene transition:_sceneTransition];
    
    [self removeUIKitView];
}

- (void)removeUIKitView
{
    [_startBtn removeFromSuperview];
}

@end
