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

@property (weak, nonatomic) SKLabelNode* selectNode;

@property (strong,nonatomic)UIButton* startBtn;

@property (strong,nonatomic)UIButton* gameCenterBtn;

@property (strong,nonatomic)UIButton* settingBtn;

@property (strong,nonatomic)UIView* gameLogoView;

@end

@implementation SXGameMenuScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = UIColorFromRGB(0x7ED321);
        
        SKLabelNode* startLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        [startLabel setText:@"Start"];
        [startLabel setFontSize:40];
        startLabel.position = CGPointMake(size.width/2, size.height/2);
        [self addChild:startLabel];
        [startLabel setName:@"start"];
        
        SKLabelNode* settingLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        [settingLabel setFontSize:20];
        [settingLabel setText:@"Settings"];
        settingLabel.position = CGPointMake(size.width/4, settingLabel.frame.size.height + 20);
        [self addChild:settingLabel];
        [settingLabel setName:@"setting"];
        
        SKLabelNode* leadboardLabel = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        [leadboardLabel setText:@"Leadboard"];
        [leadboardLabel setFontSize:20];
        leadboardLabel.position = CGPointMake(3*size.width/4, leadboardLabel.frame.size.height + 20);
        [self addChild:leadboardLabel];
        [leadboardLabel setName:@"leadboard"];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInNode:self];
    SKLabelNode* labelNode = (SKLabelNode*)[self nodeAtPoint:pt];
    if ([labelNode isKindOfClass:[SKLabelNode class]] && [labelNode containsPoint:pt]) {
        [labelNode runAction:[SKAction playSoundFileNamed:@"buttonclick.mp3" waitForCompletion:NO] completion:nil];
        [labelNode setFontColor:[SKColor redColor]];
        [labelNode setScale:1.2f];
        _selectNode = labelNode;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_selectNode setFontColor:[SKColor whiteColor]];
    [_selectNode setScale:1.0f];
    _selectNode = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_selectNode setFontColor:[SKColor whiteColor]];
    [_selectNode setScale:1.0f];
    CGPoint pt = [[touches anyObject] locationInNode:self];
    if (![_selectNode containsPoint:pt]) {
        return;
    }
    if ([_selectNode.name isEqualToString:@"start"]) {
        [self transferToMainGameScene:_selectNode];
    } else if ([_selectNode.name isEqualToString:@"setting"]) {
        [self handleSetting:_selectNode];
    } else if ([_selectNode.name isEqualToString:@"leadboard"]) {
        [self handleGameCenterTap:self];
    }
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
}

@end
