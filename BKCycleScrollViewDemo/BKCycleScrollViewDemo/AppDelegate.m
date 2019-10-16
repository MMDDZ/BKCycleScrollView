//
//  AppDelegate.m
//  BKCycleScrollViewDemo
//
//  Created by zhaolin on 2019/10/12.
//  Copyright © 2019 BIKE. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor blackColor];
    
    ViewController * vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
