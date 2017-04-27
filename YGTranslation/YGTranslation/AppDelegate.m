//
//  AppDelegate.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/29.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "AppDelegate.h"
#import "DYMainVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    DYMainVC  * vc = [[DYMainVC alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
