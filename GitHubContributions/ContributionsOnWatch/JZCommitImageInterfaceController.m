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

@interface JZCommitImageInterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *commitImage;
@end

@implementation JZCommitImageInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSMutableArray *weeks;
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
            [self refreshFromCommits:weeks];
        }
    }

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)refreshFromCommits:(NSMutableArray *)array
{
    
    @autoreleasepool
    {
        CGRect bounds = [WKInterfaceDevice currentDevice].screenBounds;
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
        [[UIColor clearColor] setFill];
        
        float squarenBlankSize = (bounds.size.height - 54)/7;
        float squareSize = squarenBlankSize - 2.0f ;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        int frameWidth = bounds.size.width;
        int width = (int)(frameWidth / squarenBlankSize) + 1;
        for (int weekFromNow = 0; weekFromNow < width; weekFromNow ++)
        {
            NSMutableArray *week = [array objectAtIndex:weekFromNow];
            for (JZCommitDataModel *day in week)
            {
                CGRect rect = CGRectMake(bounds.size.width - (weekFromNow + 1
                                                              ) * squarenBlankSize, (day.weekDay.intValue - 1) * squarenBlankSize + 20, squareSize, squareSize);
                [day.color setFill];
                CGContextFillRect(context,rect);
            }
            
            
            JZCommitDataModel *firstDayOfWeek = [week firstObject];
            NSString* monthName = [self monthName:[firstDayOfWeek.month intValue]];
            // Setup the font specific variables
            NSDictionary *attributes = @{
                                         NSFontAttributeName   : [UIFont systemFontOfSize:14],
                                         NSStrokeWidthAttributeName    : @(0),
                                         NSForegroundColorAttributeName    : [UIColor whiteColor]
                                         };
            // Draw text with CGPoint and attributes
            [monthName drawAtPoint:CGPointMake(bounds.size.width - (weekFromNow + 1) * squarenBlankSize + 4,7 * squarenBlankSize + 20) withAttributes:attributes];
        }
        
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.commitImage setImage: im];
    }
    
}

- (NSString *)monthName:(int)month
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"J",@"F",@"M",@"A",@"M",@"J",@"J",@"A",@"S",@"O",@"N",@"D", nil];
    return [array objectAtIndex:month - 1];
}

@end



