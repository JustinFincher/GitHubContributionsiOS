//
//  JZNotificationManager.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/2.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZNotificationManager.h"
#import "JZHeader.h"
#import "JZDataVisualizationManager.h"
#import "JZCommitDataModel.h"
@implementation JZNotificationManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static JZNotificationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init])
    {
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


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

- (void) triggerSuccessNotificationWithData:(NSMutableArray *)dataArray
{
    if (![self isNotificationEnabled])
    {
        return;
    }
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Contributions Data Fetched 🤗";
    content.sound = [UNNotificationSound defaultSound];
    
    NSMutableArray *currentWeekData = [dataArray firstObject];
    JZCommitDataModel *todayData = [currentWeekData lastObject];
    
    if ([todayData.dataCount integerValue] == 0)
    {
        content.body = @"😒 You don't have any commits today!";
    }else if ([todayData.dataCount integerValue] == 1)
    {
        content.body = [NSString stringWithFormat:@"🙂 You have %@ commit today!",todayData.dataCount];
    }
    else if ([todayData.dataCount integerValue] > 1 && [todayData.dataCount integerValue] <= 200)
    {
        content.body = [NSString stringWithFormat:@"😘 You have %@ commits today!",todayData.dataCount];
    }else if ([todayData.dataCount integerValue] > 200)
    {
        // This crazy shit is for Sergio Chan (aka 陈叔) 🙄
        content.body = [NSString stringWithFormat:@"😱 You have %@ commits today!",todayData.dataCount];
    }
    
    UNNotificationAction *shareAction = [UNNotificationAction actionWithIdentifier:@"shareCommits" title:@"I want share this! 😎" options:UNNotificationActionOptionForeground];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"JZNotificationCategoryIdentifer" actions:@[shareAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
    content.categoryIdentifier = @"JZNotificationCategoryIdentifer";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"CommitImage.png"];
    [UIImagePNGRepresentation([[JZDataVisualizationManager sharedManager] commitImageWithRect:CGRectMake(0, 0, 2000, 500) OS:JZDataVisualizationOSType_iOS_Notification])  writeToFile:filePath atomically:YES];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    UNNotificationAttachment *attch = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:url options:nil error:nil];
    content.attachments = @[attch];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1
                                                                                                    repeats:NO];
    NSString *identifier = [NSString stringWithFormat:@"Notif%@",[NSDate date]];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
    {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
}

- (void) triggerFailedNotification
{
    if (![self isNotificationEnabled])
    {
        return;
    }
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Contributions Fetch Failed 😢";
    content.sound = [UNNotificationSound defaultSound];
    content.body = @"There is something wrong with data parsing, if this happens again, please file a bug to my GitHub repo.😔";
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1
                                                                                                    repeats:NO];
    NSString *identifier = [NSString stringWithFormat:@"Notif%@",[NSDate date]];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
     {
         if (error != nil) {
             NSLog(@"Something went wrong: %@",error);
         }
     }];

}
@end
