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
#import "SXLogger.h"
@import Social;
@import GameKit;
@import StoreKit;

@interface SXGameResultScene()<GKGameCenterControllerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver,UIActionSheetDelegate,SKStoreProductViewControllerDelegate>

@property (assign, nonatomic) NSInteger bestScore;

@property (weak, nonatomic) SKSpriteNode* selectNode;

@property (strong, nonatomic) SKLabelNode* resultNode;

@property (strong, nonatomic) SKLabelNode* bestNode;

@property (strong, nonatomic) SKLabelNode* titleNode;

@end

@implementation SXGameResultScene

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        float scaleFactor = 2.0f;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            scaleFactor = 1.0f;
        }
        
        _titleNode = [[SKLabelNode alloc] initWithFontNamed:GAME_FONT];
        [_titleNode setText:NSLocalizedString(@"Game Over", @"xx")];
        _titleNode.fontSize = 40;
        _titleNode.position = CGPointMake(self.size.width/2, self.size.height*5/6 );
        [self addChild:_titleNode];
        
        _resultNode = [[SKLabelNode alloc] initWithFontNamed:GAME_FONT];
        //_resultNode.fontColor = UIColorFromRGB(0x00CE61);
        _resultNode.fontColor = UIColorFromRGB(0xFFDF32);
        _resultNode.position = CGPointMake(self.size.width/2, self.size.height/2+ 80);
        _resultNode.fontSize = 30;
        [self addChild:_resultNode];
        
        SKSpriteNode* restartNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Restart"] size:CGSizeMake(60, 60)];
        restartNode.name = @"restart";
        restartNode.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:restartNode];
        
        _bestNode = [[SKLabelNode alloc] initWithFontNamed:GAME_FONT];
        _bestNode.fontSize = 30;
        _bestNode.position  = CGPointMake(self.size.width/2, self.size.height/2 - 80);
        _bestNode.fontColor = UIColorFromRGB(0xFFDF32);
        [self addChild:_bestNode];
        
        SKSpriteNode* leaderBoardNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"leaderboard"] size:CGSizeMake(40, 40)];
        leaderBoardNode.name = @"leaderboard";
        leaderBoardNode.position = CGPointMake(self.size.width/2 - 60, self.size.height/6);
        [self addChild:leaderBoardNode];
        
        SKSpriteNode* rateNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Star"] size:CGSizeMake(40, 40)];
        rateNode.name = @"rate";
        rateNode.position = CGPointMake(self.size.width/2, self.size.height/6);
        [self addChild:rateNode];
        
        SKSpriteNode* shareNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"Share"] size:CGSizeMake(40, 40)];
        shareNode.name = @"share";
        shareNode.position = CGPointMake(self.size.width/2 + 60, self.size.height/6);
        [self addChild:shareNode];
        
        //comment for review
//        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"removeAds"] boolValue]) {
//        }
        
        //display the upgrade & purchase button
        SKSpriteNode* upgradeNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"RemoveAds"] size:CGSizeMake(118, 50)];
        upgradeNode.name = @"upgrade";
        upgradeNode.position = CGPointMake(self.size.width/2 - 80, 2);
        [self addChild:upgradeNode];
        
        SKSpriteNode* restoreNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"RestoreIAPs"] size:CGSizeMake(118, 50)];
        restoreNode.name = @"restore";
        restoreNode.position = CGPointMake(self.size.width/2 + 80, 2);
        [self addChild:restoreNode];
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
        [_titleNode setText:NSLocalizedString(@"New Record!",@"xx")];
        self.bestScore = self.score;
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:@"best_score"];
        scoreReporter.value = _score;
        [GKScore reportScores:@[scoreReporter] withCompletionHandler:nil];
        [_resultNode runAction:[SKAction playSoundFileNamed:@"success_playful_08.mp3" waitForCompletion:NO] completion:nil];
    }
    else
    {
        [_resultNode runAction:[SKAction playSoundFileNamed:@"horn_lose_02.mp3" waitForCompletion:NO] completion:nil];
    }
    [_resultNode setText:[NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"Score",@"xx"),(long)_score]];
    [_bestNode setText:[NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"Best", @"xxx"), (long)self.bestScore]];
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
    if ([_selectNode.name isEqualToString:@"share"]) {
       
        NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
        if ([countryCode isEqualToString:@"CN"] || [[countryCode uppercaseString] isEqualToString:@"ZH_CN"]) {
            [[[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈",@"新浪微博",nil] showInView:self.view];
        } else {
            UIActivityViewController *activityController =
            [[UIActivityViewController alloc]
             initWithActivityItems:@[[NSString stringWithFormat:@"I have just got %ld in game iPicker, challenge me right now!", (long)self.score], [NSURL URLWithString:@"https://itunes.apple.com/us/app/ipicker/id913420757?ls=1&mt=8"]]
             applicationActivities:nil];
            activityController.excludedActivityTypes = @[UIActivityTypeAirDrop,
                                                     UIActivityTypeAddToReadingList,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeSaveToCameraRoll];
            UIViewController* currectVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            [currectVC presentViewController:activityController
                               animated:YES completion:nil];
        }
        
    } else if ([_selectNode.name isEqualToString:@"restart"]) {
        [self.view presentScene:[SXGameScene sceneWithSize:self.size] transition:[SKTransition flipVerticalWithDuration:0.3f]];
        [SXLogger logRestartGame];
    } else if([_selectNode.name isEqualToString:@"leaderboard"])
    {
        GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
        [_selectNode runAction:[SKAction playSoundFileNamed:@"buttonclick.mp3" waitForCompletion:NO] completion:nil];
        if (gameCenterController != nil)
        {
            gameCenterController.gameCenterDelegate = self;
            [[[[[UIApplication sharedApplication] delegate]window]rootViewController]presentViewController:gameCenterController animated:YES completion:nil];
        }
    } else if([_selectNode.name isEqualToString:@"rate"]) {
        UIViewController* currectVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
        storeProductViewContorller.delegate = self;
        [currectVC presentViewController:storeProductViewContorller animated:YES completion:nil];
        [storeProductViewContorller loadProductWithParameters:
         @{SKStoreProductParameterITunesItemIdentifier : @"913420757"} completionBlock:^(BOOL result, NSError *error) {
             if(error){
                 [[[UIAlertView alloc] initWithTitle:@"Tips" message:@"cannot connect to iTunes Store" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             }
         }];
    } else if([_selectNode.name isEqualToString:@"upgrade"])
    {
        if([SKPaymentQueue canMakePayments])
        {
            SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"remove_ad"]];
            request.delegate = self;
            [request start];
        }
    }
    else if([_selectNode.name isEqualToString:@"restore"])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
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
                [[self childNodeWithName:@"upgrade"] removeFromParent];
                [[self childNodeWithName:@"restore"] removeFromParent];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [[[UIAlertView alloc] initWithTitle:@"Tip" message:@"Unlock Failed, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                break;
            case SKPaymentTransactionStateRestored:
                [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"removeAds"];
                [[self childNodeWithName:@"upgrade"] removeFromParent];
                [[self childNodeWithName:@"restore"] removeFromParent];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"removeAds"];
    [[[UIAlertView alloc] initWithTitle:@"Tip" message:@"Restore Completed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Tip" message:@"Restore Failed,Please Try Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
    message.title = [NSString stringWithFormat:@"我刚刚收集了%ld个iPhone", (long)_score];
    message.description = [NSString stringWithFormat:@"我刚刚收集了%ld个iPhone，快来挑战我吧！", (long)_score];
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>iPicker下载</xml>";
    ext.url = @"https://itunes.apple.com/app/ipicker/id913420757?ls=1&mt=8";
    
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
    message.text = [NSString stringWithFormat:@"我刚刚收集了%ld个iPhone，快来挑战我吧！https://itunes.apple.com/app/ipicker/id913420757?ls=1&mt=8", (long)_score];
    WBSendMessageToWeiboRequest* request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"SXViewController"};
    [WeiboSDK sendRequest:request];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
