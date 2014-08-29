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
#import "WXApi.h"
#import "WeiboSDK.h"
@import GameKit;
@import StoreKit;

@interface SXGameResultScene()<GKGameCenterControllerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver,UIActionSheetDelegate>

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
        
        SKSpriteNode* leaderBoardNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Share"] size:CGSizeMake(30, 40)];
        leaderBoardNode.name = @"leaderboard";
        leaderBoardNode.position = CGPointMake(self.size.width/2 - 60, self.size.height/2 - 150);
        [self addChild:leaderBoardNode];
        
        SKSpriteNode* upgradeNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Share"] size:CGSizeMake(30, 40)];
        upgradeNode.name = @"upgrade";
        upgradeNode.position = CGPointMake(self.size.width/2 + 60, self.size.height/2 - 150);
        [self addChild:upgradeNode];
        
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

- (void)initBannerView
{
    SXGameBannerView* bannerView = [SXGameBannerView getInstance];
    CGRect f = self.frame;
    bannerView.frame = CGRectMake( (f.size.width - bannerView.frame.size.width) / 2, ( f.size.height - bannerView.frame.size.height) /2, bannerView.frame.size.width, bannerView.frame.size.height);
    [self.view addSubview:bannerView];
    [bannerView presentBannerView];

}

- (void)didMoveToView:(SKView *)view
{
    if (self.score > self.bestScore) {
        [_resultTitleNode setText:@"New Best Score!"];
        self.bestScore = self.score;
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:@"best_score"];
        scoreReporter.value = _score;
        [GKScore reportScores:@[scoreReporter] withCompletionHandler:nil];
    }
    [_resultNode setText:[NSString stringWithFormat:@"%ld",(long)_score]];
    [_bestNode setText:[NSString stringWithFormat:@"Best %ld", (long)self.bestScore]];
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
        [[[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",@"新浪微博",nil] showInView:self.view];
    } else if ([_selectNode.name isEqualToString:@"restart"]) {
        [self.view presentScene:[SXGameScene sceneWithSize:self.size] transition:[SKTransition doorsOpenVerticalWithDuration:0.3f]];
    } else if([_selectNode.name isEqualToString:@"leaderboard"])
    {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        [_selectNode runAction:[SKAction playSoundFileNamed:@"buttonclick.mp3" waitForCompletion:NO] completion:nil];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            [[[[[UIApplication sharedApplication] delegate]window]rootViewController]presentViewController:gameCenterController animated:YES completion:nil];
        }
    } else if([_selectNode.name isEqualToString:@"upgrade"])
    {
        if([SKPaymentQueue canMakePayments])
        {
            SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"remove_ad"]];
            request.delegate = self;
            [request start];
        }
    }
}

#pragma mark -- leaderboarddelegate --
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
    if (![[GKLocalPlayer localPlayer] isAuthenticated]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
}

#pragma mark -- buy item delegate -- 
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *product = [[response products] firstObject];
    UIAlertView* alertView;
    if (product != nil) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment: payment];
    } else {
        NSString* string = NSLocalizedString(@"The Unlock System is unreachable right now,please try again a bit later", @"unreachable staff");
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tip", @"Tip") message:string delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
    }
    alertView.tag = 100;
    [alertView show];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction * transaction in transactions)
    {
        switch(transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"removeAds"];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"removeAds"];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [[[UIAlertView alloc] initWithTitle:@"Tip" message:@"Unlock Failed, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            default:
                break;
        }
    }
}



#pragma mark -- share delegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self sendImageContentToCircle:NO];
    } else if (buttonIndex == 1) {
        [self sendImageContentToCircle:YES];
    } else if (buttonIndex == 2) {
        [self sendImageContentToWeibo];
    }
}

- (void) sendImageContentToCircle:(BOOL)circle {    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"好玩的2048游戏";
    message.description = @"过来跟我一起玩吧！";
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>test</xml>";
    ext.url = @"http://www.baidu.com";
    
    Byte* pBuffer = (Byte *)malloc(1024 * 100);
    memset(pBuffer, 0, 1024 * 100);
    NSData* data = [NSData dataWithBytes:pBuffer length:1024 * 100];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = circle?WXSceneTimeline:WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)sendImageContentToWeibo {
    WBMessageObject* message = [[WBMessageObject alloc] init];
    message.text = @"好玩的2048游戏";
    WBImageObject* imageObject = [[WBImageObject alloc] init];
    imageObject.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tt1" ofType:@"png"]];
    message.imageObject = imageObject;
    WBSendMessageToWeiboRequest* request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"SXViewController"};
    [WeiboSDK sendRequest:request];
}

@end
