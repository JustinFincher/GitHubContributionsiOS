//
//  JZCommitImageInterfaceController.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2016/12/9.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZCommitImageInterfaceController.h"
#import "JZCommitManager.h"
#import "JZCommitDataModel.h"
#import "JZHeader.h"
#import "JZDataVisualizationManager.h"

@interface JZCommitImageInterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *noDataLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *commitImage;
@end

@implementation JZCommitImageInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"JZ_WATCH_USERDEFAULT_UPDATED" object:nil];
}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self refreshView];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (void)refreshView;
{
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        [self.noDataLabel setHidden:YES];
        [self.commitImage setImage: [[JZDataVisualizationManager sharedManager] commitImageWithRect:[[WKInterfaceDevice currentDevice] screenBounds] OS:JZDataVisualizationOsType_watchOS]];
    }else
    {
        [self.noDataLabel setHidden:NO];
    }
}

@end



