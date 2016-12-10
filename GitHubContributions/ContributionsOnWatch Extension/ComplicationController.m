//
//  ComplicationController.m
//  ContributionsOnWatch Extension
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "ComplicationController.h"
#import "JZComplicationDataManager.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(0);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler
{
    CLKComplicationTemplate *template = [[JZComplicationDataManager sharedManager] getComplicationFrom:complication isSample:NO];
    if (template)
    {
        CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
        handler(entry);
    }else
    {
        handler(nil);
    }
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark - Placeholder Templates

- (void)getLocalizableSampleTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached
    CLKComplicationTemplate *template =[[JZComplicationDataManager sharedManager] getComplicationFrom:complication isSample:YES];
    if (template)
    {
        handler(template);
    }else
    {
        handler(nil);
    }
}

@end
