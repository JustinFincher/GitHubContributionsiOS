//
//  NotificationController.m
//  ContributionsOnWatch Extension
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "NotificationController.h"


@interface NotificationController()

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


//- (void)didReceiveNotification:(UNNotification *)notification withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler {
//    // This method is called when a notification needs to be presented.
//    // Implement it if you use a dynamic notification interface.
//    // Populate your dynamic notification interface as quickly as possible.
//    //
//    // After populating your dynamic notification interface call the completion block.
//    if ([notification.request.content.categoryIdentifier isEqualToString:@"JZNotificationCategoryIdentifer"])
//    {
//        
//    }
//
//    completionHandler(WKUserNotificationInterfaceTypeCustom);
//}

@end



