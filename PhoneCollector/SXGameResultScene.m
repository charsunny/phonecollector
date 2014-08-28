//
//  SXGameResultScene.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameResultScene.h"
#import "SXGameScene.h"
#import "SXGameMenuScene.h"
#import "SXGameBannerView.h"

@interface SXGameResultScene()

@property (weak, nonatomic) SKSpriteNode* selectNode;

@property (strong, nonatomic) SKLabelNode* resultNode;

@end

@implementation SXGameResultScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        SKLabelNode* resultTitleNode = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        [resultTitleNode setText:@"Score"];
        resultTitleNode.fontSize = 40;
        resultTitleNode.position = CGPointMake(self.size.width/2, self.size.height/2 + 100);
        [self addChild:resultTitleNode];
        
        _resultNode = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        _resultNode.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:_resultNode];
        
        SKSpriteNode* homeNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Home"] size:CGSizeMake(40, 40)];
        homeNode.name = @"home";
        homeNode.position = CGPointMake(self.size.width/2 - 60, self.size.height/2 - 100);
        [self addChild:homeNode];
        
        SKSpriteNode* restartNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Restart"] size:CGSizeMake(40, 40)];
        restartNode.name = @"restart";
        restartNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 100);
        [self addChild:restartNode];
        
        SKSpriteNode* shareNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Share"] size:CGSizeMake(30, 40)];
        shareNode.name = @"share";
        shareNode.position = CGPointMake(self.size.width/2 + 60, self.size.height/2 - 100);
        [self addChild:shareNode];
        
    }
    return self;
}

- (void)initBannerView
{
    SXGameBannerView* bannerView = [SXGameBannerView getInstance];
    //[bannerView preLoadAds];
    [self.view addSubview:bannerView];
    [bannerView presentBannerView];
}

- (void)didMoveToView:(SKView *)view
{
    [_resultNode setText:[NSString stringWithFormat:@"%ld",(long)_score]];
    [self initBannerView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInNode:self];
    SKSpriteNode* labelNode = (SKSpriteNode*)[self nodeAtPoint:pt];
    if ([labelNode isKindOfClass:[SKSpriteNode class]] && [labelNode containsPoint:pt]) {
        [labelNode runAction:[SKAction playSoundFileNamed:@"buttonclick.mp3" waitForCompletion:NO] completion:nil];
        [labelNode setScale:1.2f];
        _selectNode = labelNode;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [_selectNode setScale:1.0f];
    _selectNode = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_selectNode setScale:1.0f];
    CGPoint pt = [[touches anyObject] locationInNode:self];
    if (![_selectNode containsPoint:pt]) {
        return;
    }
    if ([_selectNode.name isEqualToString:@"home"]) {
        [self.view presentScene:[SXGameMenuScene sceneWithSize:self.size] transition:[SKTransition doorsOpenVerticalWithDuration:0.3f]];
    } else if ([_selectNode.name isEqualToString:@"share"]) {
        
    } else if ([_selectNode.name isEqualToString:@"restart"]) {
        [self.view presentScene:[SXGameScene sceneWithSize:self.size] transition:[SKTransition doorsOpenVerticalWithDuration:0.3f]];
    }
}


@end
