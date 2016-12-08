//
//  JZComplicationDataManager.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZComplicationDataManager.h"
#import "JZHeader.h"
#import "JZCommitManager.h"
#import "JZCommitDataModel.h"

@implementation JZComplicationDataManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static JZComplicationDataManager *sharedMyManager = nil;
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


- (CLKComplicationTemplate *)getComplicationFrom:(CLKComplication *)complication
                                        isSample:(BOOL)sampleBool
{
    NSMutableArray *weeks;
    JZCommitDataModel *today;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        weeks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!weeks)
        {
            JZLog(@"NSUserDefaults DO NOT HAVE weeks DATA");
        }else
        {
            JZLog(@"NSUserDefaults DO HAVE weeks DATA");
            NSMutableArray *week = [weeks objectAtIndex:0];
            today = [week lastObject];
        }
    }
    if (!today)
    {
        return nil;
    }
    
    switch (complication.family)
    {
        case CLKComplicationFamilyCircularSmall:
        {
            CLKComplicationTemplateCircularSmallStackImage *circularSmallStackImage = [[CLKComplicationTemplateCircularSmallStackImage alloc] init];
            circularSmallStackImage.line1ImageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            circularSmallStackImage.line1ImageProvider.tintColor = UIColorFromRGB(0x3FA43A);            circularSmallStackImage.line2TextProvider
 = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d",[today.dataCount intValue]]];
            circularSmallStackImage.line2TextProvider
.tintColor = today.color;
            
            return circularSmallStackImage;
        }
            break;
        case CLKComplicationFamilyModularSmall:
        {
            CLKComplicationTemplateModularSmallSimpleImage *modularSmallSimpleImage = [[CLKComplicationTemplateModularSmallSimpleImage alloc] init];
            modularSmallSimpleImage.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            modularSmallSimpleImage.imageProvider.tintColor = UIColorFromRGB(0x3FA43A);
            return modularSmallSimpleImage;
        }
            break;
            
        case CLKComplicationFamilyUtilitarianSmall:
        {
            CLKComplicationTemplateUtilitarianSmallFlat *utilitarianSmallFlat = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            utilitarianSmallFlat.imageProvider = [CLKImageProvider imageProviderWithOnePieceImage:[UIImage imageNamed:@"Watch_Complication_Template"]];
            utilitarianSmallFlat.imageProvider.tintColor = UIColorFromRGB(0x3FA43A);
            utilitarianSmallFlat.textProvider
            = [CLKTextProvider localizableTextProviderWithStringsFileTextKey:[NSString stringWithFormat:@"%d",[today.dataCount intValue]]];
            utilitarianSmallFlat.textProvider
            .tintColor = today.color;

            return utilitarianSmallFlat;
        }
            break;
        default:
            return nil;
            break;
    }
    
}


@end
