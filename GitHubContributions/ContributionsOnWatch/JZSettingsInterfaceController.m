//
//  JZSettingsInterfaceController.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZSettingsInterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface JZSettingsInterfaceController ()

@end

@implementation JZSettingsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)refreshMenuPressed
{
    if ([WCSession isSupported])
    {
        WCSession* session = [WCSession defaultSession];
        if (session.activationState != WCSessionActivationStateActivated)
        {
            [session activateSession];
        }
    }
    for (CLKComplication *complication in [CLKComplicationServer sharedInstance].activeComplications)
    {
        [[CLKComplicationServer sharedInstance] reloadTimelineForComplication:complication];
    }
}

@end



