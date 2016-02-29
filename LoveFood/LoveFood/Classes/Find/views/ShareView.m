//
//  ShareView.m
//  LoveFood
//
//  Created by SCJY on 16/1/28.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ShareView.h"
#import <ShareSDK/ShareSDK.h>
@interface ShareView()
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *blackView;


@end@implementation ShareView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    [window addSubview:self.blackView];
    
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeigth, kWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];
    
    
    
    //微博
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(kWidth/9, 20, kWidth/9*2, 120);
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/18, 20, kWidth / 6, 60)];
    image.image = [UIImage imageNamed:@"weibo"];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/18, 80,kWidth/9*2, 20)];
    label1.text = @"分享到微博";
    label1.font = [UIFont systemFontOfSize:12];
    
    [weiboBtn addSubview:image];
    [weiboBtn addSubview:label1];
    [weiboBtn addTarget:self action:@selector(weiboShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    //朋友
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(kWidth/9+kWidth/4, 20, kWidth/9*2, 120);
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/18+kWidth/4, 20, kWidth/6, 60)];
    image1.image = [UIImage imageNamed:@"weixin"];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/18+kWidth/4, 80, kWidth/9*2, 20)];
    label2.text = @"分享给朋友";
    [weiboBtn addSubview:image1];
    [weiboBtn addSubview:label2];
    label2.font = [UIFont systemFontOfSize:12];
    
    [friendBtn addTarget:self action:@selector(friendShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendBtn];
    
    
    //朋友圈
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(kWidth/9+kWidth/2, 20, kWidth/9*2, 120);
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2+kWidth/18, 20, kWidth/6, 60)];
    image2.image = [UIImage imageNamed:@"circle"];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2+kWidth/18, 80, kWidth/9*3, 20)];
    label3.text = @"分享到朋友圈";
    label3.font = [UIFont systemFontOfSize:12];
    [weiboBtn addSubview:image2];
    [weiboBtn addSubview:label3];
    
    [circleBtn addTarget:self action:@selector(circleShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:circleBtn];
    
    //取消按钮
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(70, 130, kWidth - 140, 40);
    removeBtn.backgroundColor = kMainColor;
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.blackView.alpha = 0.6;
        self.shareView.frame = CGRectMake(0, kHeigth - 200, kWidth, 200);
    }];
    
    
}

- (void)removeView{
    [UIView animateWithDuration:0.6 animations:^{
        self.shareView.frame = CGRectMake(0, kHeigth, kWidth, 200);
        self.blackView.frame = CGRectMake(0, 0, kWidth, kHeigth);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
    
}
- (void)cancel{
    [self removeView];
}

- (void)weiboShare{
    
    
    
<<<<<<< HEAD
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"head.png"]];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ @value(url)", @"i吃货" ]images:imageArray url:[NSURL URLWithString:@"http://www.mob.com"] title:@"分享标题" type:SSDKContentTypeImage];
    }
    
    //2、分享
    [ShareSDK share:SSDKPlatformTypeSinaWeibo
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                 [alertView show];
                 break;
=======
        //1、创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        NSArray* imageArray = @[[UIImage imageNamed:@"head.png"]];
        if (imageArray)
        {
            [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ @value(url)", @"i吃货" ]images:imageArray url:[NSURL URLWithString:@"http://www.mob.com"] title:@"分享标题" type:SSDKContentTypeImage];
        }
    
        //2、分享
        [ShareSDK share:SSDKPlatformTypeSinaWeibo
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
         {
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     break;
                 }
                 default:
                     break;
>>>>>>> af95301cdf8415c5582bad8f7d91aa01f4e115cf
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
     }];
    [self removeView];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
}
- (void)friendShare{
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"find.png"]];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ @value(url)", @"i吃货" ]images:imageArray url:[NSURL URLWithString:@"http://www.mob.com"] title:@"分享标题" type:SSDKContentTypeImage];
    }
    
    //2、分享
    [ShareSDK share:SSDKPlatformTypeWechat
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
     }];
    [self removeView];
    
}
- (void)circleShare{
    
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[UIImage imageNamed:@"find.png"]];
    if (imageArray)
    {
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ @value(url)", @"i吃货" ]images:imageArray url:[NSURL URLWithString:@"http://www.mob.com"] title:@"分享标题" type:SSDKContentTypeImage];
    }
    
    //2、分享
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
     }];
    [self removeView];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
