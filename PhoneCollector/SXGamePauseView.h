//
//  SXGamePauseView.h
//  PhoneCollector
//
//  Created by Lanston Peng on 8/27/14.
//  Copyright (c) 2014 Sun Xi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SXGamePauseViewDelegate <NSObject>

- (void)handleRestart:(UIButton*)button;

- (void)handleResume:(UIButton*)button;

- (void)handleHome:(UIButton*)button;

@end

@interface SXGamePauseView : UIView

@property (weak, nonatomic) id<SXGamePauseViewDelegate> delegate;

- (void)initUI;

@end
