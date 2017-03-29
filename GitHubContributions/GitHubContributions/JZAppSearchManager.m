//
//  JZAppSearchManager.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/31.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZAppSearchManager.h"
#import "JZHeader.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "JZCommitManager.h"

@implementation JZAppSearchManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static JZAppSearchManager *sharedMyManager = nil;
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


- (void)updateAppSearchResult
{
    
    if ([[JZCommitManager sharedManager] haveUserID] && [[JZCommitManager sharedManager] haveUserCommits])
    {
        NSString *userID = [[JZCommitManager sharedManager] getUserID];
        NSInteger todayNum = [[JZCommitManager sharedManager] getDayContributionNum];
        NSInteger weekNum = [[JZCommitManager sharedManager] getWeekContributionNum];
        
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeText];
        attributeSet.title = [NSString stringWithFormat:@"%@ 's GitHub Stats",userID];
        attributeSet.contentDescription = [NSString stringWithFormat:@"Contributions: Today: %ld | This Week: %ld",(long)todayNum,(long)weekNum];
        attributeSet.keywords = [NSArray arrayWithObjects:@"git",@"GitHub",@"Contributions",userID, nil];
        
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"com.JustZht.GitHubContributions.Spotlight.Stats" domainIdentifier:@"spotlight.contributions.dayandweek" attributeSet:attributeSet];
        
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError *err)
         {
             if (err)
             {
                 JZLog(@"%@",[err debugDescription]);
             }
         }];
    }
}
@end
