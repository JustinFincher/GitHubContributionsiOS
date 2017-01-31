//
//  JZAppSearchManager.h
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/31.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZAppSearchManager : NSObject

+ (id)sharedManager;
- (void)updateAppSearchResult;

@end
