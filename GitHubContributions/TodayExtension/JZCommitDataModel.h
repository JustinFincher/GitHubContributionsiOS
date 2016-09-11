//
//  JZCommitDataModel.h
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JZCommitDataModel : NSObject

@property (nonatomic,strong) NSDate * date;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) NSNumber *dataCount;
@property (nonatomic,strong) NSNumber *weekDay;
@property (nonatomic,strong) NSNumber *month;

@end

@interface JZCommitWeekDataModel : NSObject

@property (nonatomic,strong) NSMutableArray *commits;

@end
