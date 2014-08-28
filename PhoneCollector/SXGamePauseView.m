//
//  SXGamePauseView.m
//  PhoneCollector
//
//  Created by Lanston Peng on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import "SXGamePauseView.h"


#define BTN_WIDTH 50

@implementation SXGamePauseView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self initUI];
    }
    return self;
}

- (void)configureButton:(UIButton*)button
{
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"handle%@:",button.titleLabel.text]);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.alpha = 0;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",button.titleLabel.text]] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    button.imageView.clipsToBounds = NO;
    [self addSubview:button];
}
- (void)initUI
{
    CGSize fs = self.frame.size;
    CGFloat padding = ( fs.width - 3 * BTN_WIDTH ) / 4;
    
    //restart
    UIButton* restartBtn = [[UIButton alloc]initWithFrame:CGRectMake(padding, fs.height / 2 , BTN_WIDTH, BTN_WIDTH)];
    [restartBtn setTitle:@"Restart" forState:UIControlStateNormal];
    [self configureButton:restartBtn];
    
    //resume
    UIButton* resumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(restartBtn.frame.origin.x + BTN_WIDTH + padding, fs.height / 2, BTN_WIDTH, BTN_WIDTH)];
    [resumeBtn setTitle:@"Resume" forState:UIControlStateNormal];
    [self configureButton:resumeBtn];
    
    //home
    UIButton* homeBtn = [[UIButton alloc]initWithFrame:CGRectMake(resumeBtn.frame.origin.x +  BTN_WIDTH + padding, fs.height / 2, BTN_WIDTH, BTN_WIDTH)];
    [homeBtn setTitle:@"Home" forState:UIControlStateNormal];
    [self configureButton:homeBtn];
    
    //UIView* spLineUp = [UIView alloc]initWithFrame:CGRectMake(, , , )
    //UIView* spLineBottom = [UIView alloc]initWithFrame:CGRectMake(, , , )
    //voice
}

- (void)handleRestart:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(handleRestart:)]) {
        [self.delegate handleRestart:button];
    }
}

- (void)handleResume:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(handleResume:)]) {
        [self.delegate handleResume:button];
    }
}

- (void)handleHome:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(handleHome:)]) {
        [self.delegate handleHome:button];
    }
}
@end
