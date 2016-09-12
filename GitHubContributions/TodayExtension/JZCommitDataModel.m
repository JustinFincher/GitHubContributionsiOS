//
//  JZCommitDataModel.m
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZCommitDataModel.h"

@implementation JZCommitDataModel

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.date = [decoder decodeObjectForKey:@"date"];
    self.color = [decoder decodeObjectForKey:@"color"];
    self.weekDay = [decoder decodeObjectForKey:@"weekDay"];
    self.dataCount = [decoder decodeObjectForKey:@"dataCount"];
    self.month = [decoder decodeObjectForKey:@"month"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.color forKey:@"color"];
    [encoder encodeObject:self.weekDay forKey:@"weekDay"];
    [encoder encodeObject:self.dataCount forKey:@"dataCount"];
    [encoder encodeObject:self.month forKey:@"month"];
}


@end


@implementation JZCommitWeekDataModel

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.commits = [decoder decodeObjectForKey:@"commits"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.commits forKey:@"commits"];
}


@end
