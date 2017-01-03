//
//  JZNotificationManager.h
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/2.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZNotificationManager : NSObject

- (BOOL) isNotificationEnabled;

- (void) triggerNotificationNow;

@end
