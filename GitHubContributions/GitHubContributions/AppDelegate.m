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
#import <WatchConnectivity/WatchConnectivity.h>
#import "JZHeader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<WCSessionDelegate>

@property (nonatomic) Reachability *hostReachability;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#if DEBUG
#else
    [Fabric with:@[[Crashlytics class],[Answers class]]];
#endif
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                                                                        completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (!error)
         {
             
         }
     }];
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:900];
    if ([WCSession isSupported])
    {
        WCSession* session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle] forKey:@"com.JustZht.GitHubContributions.Bundle.Settings.LastFetchTimeTitle"];
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Contributions Debug Task";
    content.body = @"Doing Background Fetch";
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1
                                                                                                    repeats:NO];
    NSString *identifier = [NSString stringWithFormat:@"Notif%@",[NSDate date]];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
    
    NetworkStatus netStatus = [self.hostReachability currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            JZLog(@"NetworkStatus NotReachable");
            JZLog(@"UIBackgroundFetchResultNoData");
            completionHandler(UIBackgroundFetchResultNoData);
            return;
            break;
        }
        case ReachableViaWWAN:
        {
            JZLog(@"NetworkStatus ReachableViaWWAN");
            break;
        }
        case ReachableViaWiFi:
        {
            JZLog(@"NetworkStatus ReachableViaWiFi");
            break;
        }
    }
    
    
    NSMutableArray * array = [[JZCommitManager sharedManager] refresh];
    if (array)
    {
        [Answers logCustomEventWithName:@"com.JustZht.GitHubContributions.BackgroundFetch.Success"
                       customAttributes:@{}];
        
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = @"Contributions Debug Task";
        content.body = @"Background Fetch Success";
        content.sound = [UNNotificationSound defaultSound];
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1
                                                                                                        repeats:NO];
        NSString *identifier = [NSString stringWithFormat:@"Notif%@",[NSDate date]];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                              content:content trigger:trigger];
        
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Something went wrong: %@",error);
            }
        }];
        
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array] ;
        [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] setObject:data forKey:@"GitHubContributionsArray"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle] forKey:@"com.JustZht.GitHubContributions.Bundle.Settings.LastSuccessFetchTimeTitle"];
        
        JZLog(@"UIBackgroundFetchResultNewData");
        [self syncUserDefaultToWatch];
        completionHandler(UIBackgroundFetchResultNewData);
    }
    else
    {
        [Answers logCustomEventWithName:@"com.JustZht.GitHubContributions.BackgroundFetch.Fail"
                       customAttributes:@{}];
        
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = @"Contributions Debug Task";
        content.body = @"Background Fetch Failed";
        content.sound = [UNNotificationSound defaultSound];
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1
                                                                                                        repeats:NO];
        NSString *identifier = [NSString stringWithFormat:@"Notif%@",[NSDate date]];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                              content:content trigger:trigger];
        
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"Something went wrong: %@",error);
            }
        }];
        
        JZLog(@"UIBackgroundFetchResultNoData");
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)syncUserDefaultToWatch
{
    WCSession* session = [WCSession defaultSession];
    if ([session activationState] == WCSessionActivationStateActivated)
    {
        [session transferUserInfo:[[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] dictionaryRepresentation]];
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

#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error
{
    [self syncUserDefaultToWatch];
}
- (void)sessionDidBecomeInactive:(WCSession *)session
{}
- (void)sessionDidDeactivate:(WCSession *)session
{}

@end
