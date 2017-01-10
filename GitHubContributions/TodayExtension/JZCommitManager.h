//
//  JZCommitManager.h
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZCommitManager : NSObject

+ (id)sharedManager;

@property (nonatomic,strong) NSMutableArray *commits;
- (NSMutableArray *)getCommits;
- (NSMutableArray *)refresh;

- (BOOL)haveUserID;
- (BOOL)haveUserCommits;
@end
