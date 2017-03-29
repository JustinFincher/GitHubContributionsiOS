//
//  ExtensionDelegate.m
//  ContributionsOnWatch Extension
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "ExtensionDelegate.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "JZHeader.h"
#import <UserNotifications/UserNotifications.h>

@interface ExtensionDelegate()<WCSessionDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic,strong) NSMutableArray *wcBackgroundTasks;

@end

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching
{
    self.wcBackgroundTasks = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateComplications) name:CLKComplicationServerActiveComplicationsDidChangeNotification object:nil];
    WCSession* session = [WCSession defaultSession];
    [session addObserver:self forKeyPath:@"activationState" options:0 context:nil];
    [session addObserver:self forKeyPath:@"hasContentPending" options:0 context:nil];
    session.delegate = self;
    [session activateSession];
}
- (void)dealloc
{
    WCSession* session = [WCSession defaultSession];
    [session removeObserver:self forKeyPath:@"activationState"];
    [session removeObserver:self forKeyPath:@"hasContentPending"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        //non-main thread.
        [self completeAllTasksIfReady];
        dispatch_async(dispatch_get_main_queue(), ^
        {
            //main thread.

        });
    });
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}
- (void)completeAllTasksIfReady
{
    WCSession* session = [WCSession defaultSession];
    if (session.activationState == WCSessionActivationStateActivated && !session.hasContentPending)
    {
        for (WKRefreshBackgroundTask *task in self.wcBackgroundTasks)
        {
            [task setTaskCompleted];
        }
        [self.wcBackgroundTasks removeAllObjects];
    }
}

- (void)handleBackgroundTasks:(NSSet<WKRefreshBackgroundTask *> *)backgroundTasks {
    // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
    for (WKRefreshBackgroundTask * task in backgroundTasks) {
        // Check the Class of each task to decide how to process it
        if ([task isKindOfClass:[WKApplicationRefreshBackgroundTask class]])
        {
            // Be sure to complete the background task once you’re done.
            WKApplicationRefreshBackgroundTask *backgroundTask = (WKApplicationRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else if ([task isKindOfClass:[WKSnapshotRefreshBackgroundTask class]]) {
            // Snapshot tasks have a unique completion call, make sure to set your expiration date
            WKSnapshotRefreshBackgroundTask *snapshotTask = (WKSnapshotRefreshBackgroundTask*)task;
            [snapshotTask setTaskCompletedWithDefaultStateRestored:NO estimatedSnapshotExpiration:[NSDate distantFuture] userInfo:nil];
        } else if ([task isKindOfClass:[WKWatchConnectivityRefreshBackgroundTask class]])
        {
            // Be sure to complete the background task once you’re done.
            WKWatchConnectivityRefreshBackgroundTask *backgroundTask = (WKWatchConnectivityRefreshBackgroundTask*)task;
            [self.wcBackgroundTasks addObject:backgroundTask];
        } else if ([task isKindOfClass:[WKURLSessionRefreshBackgroundTask class]]) {
            // Be sure to complete the background task once you’re done.
            WKURLSessionRefreshBackgroundTask *backgroundTask = (WKURLSessionRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else {
            // make sure to complete unhandled task types
            [task setTaskCompleted];
        }
    }
    [self completeAllTasksIfReady];
}

#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(NSError *)error
{
    if (error)
    {
        JZLog(@"%@",[error localizedDescription]);
    }
}
- (void)sessionDidBecomeInactive:(WCSession *)session
{
    
}
- (void)sessionDidDeactivate:(WCSession *)session
{
    
}
- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:JZSuiteName];
    
    for (NSString *key in userInfo.allKeys)
    {
        [defaults setObject:[userInfo objectForKey:key] forKey:key];
    }
    
    if ([defaults synchronize])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_WATCH_USERDEFAULT_UPDATED" object:nil];
        [self updateComplications];
    }
    
    
}
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:JZSuiteName];
    
    for (NSString *key in message.allKeys)
    {
        [defaults setObject:[message objectForKey:key] forKey:key];
    }
    
    if ([defaults synchronize])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JZ_WATCH_USERDEFAULT_UPDATED" object:nil];
        [self updateComplications];
    }
}

- (void)updateComplications
{
    for (CLKComplication *complication in [[CLKComplicationServer sharedInstance] activeComplications])
    {
        [[CLKComplicationServer sharedInstance] reloadTimelineForComplication:complication];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    if ([response.actionIdentifier isEqualToString:@"shareCommits"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
    }
    completionHandler();
}

@end
