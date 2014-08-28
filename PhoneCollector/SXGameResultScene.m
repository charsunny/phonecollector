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

@interface SXGameResultScene()

@property (assign, nonatomic) NSInteger bestScore;

@property (weak, nonatomic) SKSpriteNode* selectNode;

@property (strong, nonatomic) SKLabelNode* resultNode;

@property (strong, nonatomic) SKLabelNode* bestNode;

@property (strong, nonatomic) SKLabelNode* resultTitleNode;

@end

@implementation SXGameResultScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        SKLabelNode* gameoverLabel = [[SKLabelNode alloc] initWithFontNamed:GAME_FONT];
        [gameoverLabel setText:@"Game Over"];
        gameoverLabel.fontSize = 40;
        gameoverLabel.position = CGPointMake(self.size.width/2, self.size.height*3/4 );
        [self addChild:gameoverLabel];
        
        _resultTitleNode = [[SKLabelNode alloc] initWithFontNamed:GAME_FONT];
        [_resultTitleNode setText:@"Score"];
        _resultTitleNode.fontSize = 30;
        _resultTitleNode.position = CGPointMake(self.size.width/2, self.size.height/2 + 60);
        [self addChild:_resultTitleNode];
        
        _resultNode = [[SKLabelNode alloc] initWithFontNamed:GAME_FONT];
        _resultNode.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:_resultNode];
        
        _bestNode = [[SKLabelNode alloc] initWithFontNamed:GAME_FONT];
        _bestNode.fontSize = 30;
        _bestNode.position  = CGPointMake(self.size.width/2, self.size.height/2 - 60);
        [self addChild:_bestNode];
        
        SKSpriteNode* homeNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Home"] size:CGSizeMake(40, 40)];
        homeNode.name = @"home";
        homeNode.position = CGPointMake(self.size.width/2 - 60, self.size.height/2 - 110);
        [self addChild:homeNode];
        
        SKSpriteNode* restartNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Restart"] size:CGSizeMake(40, 40)];
        restartNode.name = @"restart";
        restartNode.position = CGPointMake(self.size.width/2, self.size.height/2 - 110);
        [self addChild:restartNode];
        
        SKSpriteNode* shareNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Share"] size:CGSizeMake(30, 40)];
        shareNode.name = @"share";
        shareNode.position = CGPointMake(self.size.width/2 + 60, self.size.height/2 - 110);
        [self addChild:shareNode];
        
    }
    return self;
}

- (NSInteger)bestScore {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestscore"] integerValue];
}

- (void)setBestScore:(NSInteger)bestScore {
    _score = bestScore;
    [[NSUserDefaults standardUserDefaults] setValue:@(bestScore) forKey:@"bestscore"];
}

- (void)didMoveToView:(SKView *)view
{
    if (self.score > self.bestScore) {
        [_resultTitleNode setText:@"New Best Score!"];
        self.bestScore = self.score;
    }
    [_resultNode setText:[NSString stringWithFormat:@"%ld",(long)_score]];
    [_bestNode setText:[NSString stringWithFormat:@"Best %ld", (long)self.bestScore]];
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
