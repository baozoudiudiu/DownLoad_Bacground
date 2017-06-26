//
//  AppDelegate.m
//  DownloadBackgroundTest
//
//  Created by chenwang on 2017/6/26.
//  Copyright © 2017年 chenwang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) ViewController *viewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]);
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    
    NSLog(@"handleEventsForBackgroundURLSession");
    
    self.viewController = [[ViewController alloc] init];
    NSURLSession *backgroundSession = [self.viewController session];
    NSLog(@"Rejoining session with identifier %@ %@", identifier, backgroundSession);
    [self addCompletionHandler:completionHandler forSession:identifier];
    
    
}
- (void)addCompletionHandler:(void (^)())handler
                  forSession:(NSString *)identifier {
    
    self.viewController.complete = handler;
    
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
    NSLog(@"....");
    [[NSUserDefaults standardUserDefaults] setObject:@(10000) forKey:@"testKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
