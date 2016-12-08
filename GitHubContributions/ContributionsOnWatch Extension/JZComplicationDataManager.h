//
//  JZComplicationDataManager.h
//  GitHubContributions
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ClockKit/ClockKit.h>

@interface JZComplicationDataManager : NSObject

+ (id)sharedManager;

- (CLKComplicationTemplate *)getComplicationFrom:(CLKComplication *)complication
                                        isSample:(BOOL)sampleBool;

@end
