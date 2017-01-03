//
//  JZNotificationManager.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/2.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZNotificationManager.h"
#import "JZHeader.h"

@implementation JZNotificationManager

- (BOOL) isNotificationEnabled
{
    NSNumber *userDefaultNotificationEnabledNumber = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] objectForKey:@"NotificationEnabled"];
    if (userDefaultNotificationEnabledNumber)
    {
        return [userDefaultNotificationEnabledNumber boolValue];
    }else
    {
        return NO;
    }
}

- (void) triggerNotificationNow
{
    
}
@end
