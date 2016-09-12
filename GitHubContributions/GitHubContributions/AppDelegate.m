//
//  AppDelegate.m
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "JZCommitManager.h"

@interface AppDelegate ()

@property (nonatomic) Reachability *hostReachability;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //Change the host name here to change the server you want to monitor.
    NSString *remoteHostName = @"github.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    return YES;
}


/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
//        BOOL connectionRequired = [reachability connectionRequired];
        
        switch (netStatus)
        {
            case NotReachable:
            {
                
                break;
            }
                
            case ReachableViaWWAN:
            {
                
                break;
            }
            case ReachableViaWiFi:
            {
                break;
            }
        }
    }
    
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NetworkStatus netStatus = [self.hostReachability currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"NetworkStatus NotReachable");
            NSLog(@"UIBackgroundFetchResultFailed");
            completionHandler(UIBackgroundFetchResultFailed);
            return;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"NetworkStatus ReachableViaWWAN");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"NetworkStatus ReachableViaWiFi");
            break;
        }
    }

//    NSMutableArray * oldArray = [[[NSUserDefaults alloc] initWithSuiteName:@"UYK8GY9WS7.group.com.JustZht.GitHubContributions"] objectForKey:@"GitHubContributionsArray"];
    NSMutableArray * array = [[JZCommitManager sharedManager] refresh];
    if (array)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array] ;
        [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] setObject:data forKey:@"GitHubContributionsArray"];
        if ([[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] synchronize])
        {
            NSLog(@"UIBackgroundFetchResultNewData");
            completionHandler(UIBackgroundFetchResultNewData);
        }else
        {
            NSLog(@"UIBackgroundFetchResultFailed");
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }
    else
    {
        NSLog(@"UIBackgroundFetchResultFailed");
        completionHandler(UIBackgroundFetchResultFailed);
    }
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
}


@end
