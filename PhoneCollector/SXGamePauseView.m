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
    [self addSubview:button];
}
- (void)initUI
{
    CGRect f = self.frame;
    //background view
    
    //restart
    UIButton* restartBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, f.size.height / 2 , BTN_WIDTH, BTN_WIDTH)];
    [restartBtn setTitle:@"Restart" forState:UIControlStateNormal];
    [self configureButton:restartBtn];
    
    //resume
    UIButton* resumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(BTN_WIDTH + 10, f.size.height / 2, BTN_WIDTH, BTN_WIDTH)];
    [resumeBtn setTitle:@"Resume" forState:UIControlStateNormal];
    [self configureButton:resumeBtn];
    
    //home
//    UIButton* homeBtn = [[UIButton alloc]initWithFrame:CGRectMake(BTN_WIDTH*2 + 10, f.size.height / 2, BTN_WIDTH, BTN_WIDTH)];
//    homeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [homeBtn setTitle:@"Home" forState:UIControlStateNormal];
//    [self configureButton:homeBtn];
    
    //voice
}

- (void)handleRestart:(UIButton*)button
{
    NSLog(@"Restart");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cmd" object:self userInfo:@{
                                                                                            @"cmd":@"restart"
                                                                                            }];
}

- (void)handleResume:(UIButton*)button
{
    NSLog(@"Resume");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cmd" object:self userInfo:@{
                                                                                            @"cmd":@"resume"
                                                                                            }];
}

- (void)handleHome:(UIButton*)button
{
    NSLog(@"Home");
}
@end
