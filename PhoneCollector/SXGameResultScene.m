//
//  SXGameResultScene.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGameResultScene.h"

@interface SXGameResultScene()

@property(strong,nonatomic)SKLabelNode* resultTitleNode;

@property(strong,nonatomic)UIButton* restartBtn;

@property(strong,nonatomic)UIButton* shareBtn;

@property(strong,nonatomic)UIButton* homeBtn;


@end

@implementation SXGameResultScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        _resultTitleNode = [SKLabelNode labelNodeWithText:@"Score"];
        _resultTitleNode.fontSize = 40;
        _resultTitleNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+45);
        [self addChild:_resultTitleNode];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
}
@end
