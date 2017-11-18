//
//  AppDelegate.m
//  BaseProject
//
//  Created by cc on 2017/6/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewViewController.h"
#import "LoginViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "WMHomePageViewController.h"
#import "UserModel.h"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //自动更新用户信息
    if ([[TMCache sharedCache] objectForKey:UserInfoModel]) {
        [self updateUserInfo];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UINavigationController * na = [[UINavigationController alloc] initWithRootViewController:[WMHomePageViewController new]];
    
//    if ([ConfigModel getBoolObjectforKey:IsLogin] == YES) {
//        na = [[UINavigationController alloc] initWithRootViewController:[WMHomePageViewController new]];
//    }else{
//        na = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
//    }
    
    self.window.rootViewController = na;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginActionWithType:) name:kLoginNotification object:nil];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [self.window makeKeyAndVisible];
    
    //设置地图
    [AMapServices sharedServices].apiKey = AMapKey;
    
    return YES;
}
- (void)updateUserInfo{
    [HttpRequest postPath:GetUserinfoURL params:nil resultBlock:^(id responseObject, NSError *error) {
        UserModel * userModel = [[UserModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"自动更新用户信息==========%@",userModel.info);
        if (userModel.error == 0) {
            userModel.info.userToken = [ConfigModel getStringforKey:UserToken];
            [[TMCache sharedCache] setObject:userModel.info forKey:UserInfoModel];
        }
    }];
}
- (void)loginActionWithType:(NSNotification *)aNote {
    /**
     *  type=0登录成功，type=1退出登录，type=2注册成功，type=3登录失败
     */
    //UINavigationController * na;
    if ([aNote.object isEqual:@0]) {
        NSLog(@"LoginSuccess");
        [ConfigModel saveBoolObject:YES forKey:IsLogin];
        //na = [[UINavigationController alloc] initWithRootViewController:[WMHomePageViewController new]];
    }else if ([aNote.object isEqual:@1]){
        NSLog(@"OutLoginSuccess");
        [ConfigModel saveBoolObject:NO forKey:IsLogin];
        [[TMCache sharedCache] removeObjectForKey:UserInfoModel];
        //na = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    }
    //self.window.rootViewController = na;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}



@end
