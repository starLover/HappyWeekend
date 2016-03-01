//
//  ShareView.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/14.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"
#import "WXApi.h"

@interface ShareView ()<WXApiDelegate>
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) UIView *shareView;
@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configShareView];
    }
    return self;
}

- (void)configShareView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.shareView];
    self.blackView = [[UIView alloc] initWithFrame:self.frame];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHieght, kScreenWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.frame = CGRectMake(0, kScreenHieght - 200, kScreenWidth, 200);
    }];
    
    [window addSubview:self.blackView];
    [window addSubview:self.shareView];
    //weibo
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(50, 40, 60, 60);
    weiboBtn.tag = 1;
    [weiboBtn setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_logo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 100, 70, 30)];
    weiboLabel.text = @"新浪微博";
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    weiboLabel.font = [UIFont systemFontOfSize:13.0];
    [self.shareView addSubview:weiboLabel];
    
    //朋友圈
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame = CGRectMake(150, 40, 60, 60);
    friendsBtn.tag = 2;
    [friendsBtn setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendsBtn];
    
    UILabel *friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 100, 70, 30)];
    friendsLabel.text = @"微信朋友圈";
    friendsLabel.textAlignment = NSTextAlignmentCenter;
    friendsLabel.font = [UIFont systemFontOfSize:13.0];
    [self.shareView addSubview:friendsLabel];
    
    //friend
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(250, 40, 60, 60);
    friendBtn.tag = 3;
    [friendBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [friendBtn setImage:[UIImage imageNamed:@"icon_pay_weixin"] forState:UIControlStateNormal];
    [self.shareView addSubview:friendBtn];
    
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 100, 70, 30)];
    friendLabel.text = @"微信朋友";
    friendLabel.textAlignment = NSTextAlignmentCenter;
    friendLabel.font = [UIFont systemFontOfSize:13.0];
    [self.shareView addSubview:friendLabel];
    
    //remove
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(0, 160, kScreenWidth, 40);
    removeBtn.tag = 4;
    removeBtn.backgroundColor = [UIColor redColor];
    [removeBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn setBackgroundColor:[UIColor redColor]];
    [self.shareView addSubview:removeBtn];
    
}
- (void)shareAction:(UIButton *)button{
    switch (button.tag) {
        case 1:
        {
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = kRedirectURI;
            authRequest.scope = @"all";
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:nil];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            [WeiboSDK sendRequest:request];
        }
            break;
        case 2:
            //微信朋友圈分享
        {
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
            req.bText = YES;
            req.scene = WXSceneTimeline;
            [WXApi sendReq:req];
            //图片分享
            WXMediaMessage *message = [WXMediaMessage message];
            [message setThumbImage:[UIImage imageNamed:@"you.png"]];
            
            WXImageObject *ext = [WXImageObject object];
            ext.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"you.png"]);
            
            message.mediaObject = ext;
            
            SendMessageToWXReq* req2 = [[SendMessageToWXReq alloc] init];
            req2.bText = NO;
            req2.scene = WXSceneTimeline;
            
            [WXApi sendReq:req2];
        }
            break;
        case 3:
        {
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
            req.bText = YES;
            req.scene = WXSceneSession;
            [WXApi sendReq:req];
        }
            break;
        case 4:
        {
        }
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.0;
        self.shareView.frame = CGRectMake(0, kScreenHieght, kScreenWidth, 200);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
}
- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = @"成长快乐,让你的孩子赢在起跑线上!";
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"you" ofType:@".png"]];
    message.imageObject = image;
    
    
    //        WBWebpageObject *webpage = [WBWebpageObject object];
    //        webpage.objectID = @"identifier1";
    //        webpage.title = @"分享网页标题";
    //        webpage.description = [NSString stringWithFormat:@"分享网页内容简介-%.0f", [[NSDate date] timeIntervalSince1970]];
    //        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
    //        webpage.webpageUrl = @"http://sina.cn?a=1";
    //        message.mediaObject = webpage;
    return message;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
