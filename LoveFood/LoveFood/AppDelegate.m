//
//  AppDelegate.m
//  LoveFood
//
//  Created by SCJY on 16/1/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <SMS_SDK/SMSSDK.h>
#import <BmobSDK/Bmob.h>

@interface AppDelegate ()<WXApiDelegate, UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SMSSDK registerApp:@"f5da6a78149c" withSecret:@"bc33316dd59a6f9a209cfa5ae42f9417"];
    [Bmob registerWithAppKey:kBMOBAppID];
    [ShareSDK registerApp:kShareAppKey activePlatforms:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeSinaWeibo)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
                {
                    case SSDKPlatformTypeWechat:
                        //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                        [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                        break;
                    case SSDKPlatformTypeSinaWeibo:
                        [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                        break;
                }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"2437667234"
                                          appSecret:@"4093adfb18c9632434efb919a9e5cd80"
                                        redirectUri:@"http://www.sharesdk.cn"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx0a8d313cd20e87dd"
                                      appSecret:@"1c36faab342b33789f32f35ba4f85b35"];
            break;}
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.tabBarVC = [[UITabBarController alloc]init];
    UIStoryboard *findStoryBoard = [UIStoryboard storyboardWithName:@"find" bundle:nil];
    UINavigationController *findNav = findStoryBoard.instantiateInitialViewController;
    findNav.tabBarItem.title = @"热门搜索";
    findNav.tabBarItem.image = [UIImage imageNamed:@"find"];
    
    UIStoryboard *favoriteStoryBoard = [UIStoryboard storyboardWithName:@"favorite" bundle:nil];
    UINavigationController *favoriteNav = favoriteStoryBoard.instantiateInitialViewController;
    favoriteNav.tabBarItem.image = [UIImage imageNamed:@"heart"];
    favoriteNav.tabBarItem.title = @"最近流行";
   
    
    UIStoryboard *moreStoryBoard = [UIStoryboard storyboardWithName:@"more" bundle:nil];
    UINavigationController *moreNav = moreStoryBoard.instantiateInitialViewController;
    moreNav.tabBarItem.image = [UIImage imageNamed:@"Settings"];
    moreNav.tabBarItem.title = @"更多";
    self.tabBarVC.tabBar.tintColor = kMainColor;
    self.tabBarVC.viewControllers = @[findNav, favoriteNav, moreNav];
    self.tabBarVC.tabBar.barTintColor = [UIColor blackColor];
    self.window.rootViewController = self.tabBarVC;
    self.tabBarVC.delegate = self;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//很多时候我们的程序操作结构都是UITabBarController+UINavigationController，每个UITabBarController item里面都有很多层的UINavigationController，而UITabBarController默认有一个事件就是双击UITabBarController item时，会把这个item里的UINavigationController pop 到root，而我们有时不希望一下子就pop到了根视图，因为可能还会有一些逐层处理功能需要完成。这个时候如果想屏闭掉这个双击事件只留下单击切换标签事件的话，就可以参考下面的方法重写UITabBarController的代理：

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *tbSelectedController = tabBarController.selectedViewController;
    
    if ([tbSelectedController isEqual:viewController]) {
        return NO;
    }
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
