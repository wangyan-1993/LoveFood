//
//  AppDelegate.m
//  LoveFood
//
//  Created by SCJY on 16/1/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
