//
//  JZNotificationManager.h
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/2.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface JZNotificationManager : NSObject

+ (id)sharedManager;

- (BOOL) isNotificationEnabled;

- (void) triggerSuccessNotificationWithData:(NSMutableArray *)dataArray;
- (void) triggerFailedNotification;
@end
