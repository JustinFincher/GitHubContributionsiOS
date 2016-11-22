//
//  JZCommitImageView.m
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZCommitImageView.h"
#import "JZCommitManager.h"
#import "JZCommitDataModel.h"
@implementation JZCommitImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder]))
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)refreshFromCommits:(NSMutableArray *)array
{
    
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        [[UIColor clearColor] setFill];
        
         CGContextRef context = UIGraphicsGetCurrentContext();
        
        int frameWidth = self.frame.size.width;
        int width = (int)(frameWidth / 12 - 1);
        for (int weekFromNow = 0; weekFromNow < width; weekFromNow ++)
        {
            NSMutableArray *week = [array objectAtIndex:weekFromNow];
            for (JZCommitDataModel *day in week)
            {
                CGRect rect = CGRectMake(self.frame.size.width - weekFromNow * 12 - 24, day.weekDay.intValue * 12 - 6, 10, 10);
                [day.color setFill];
                CGContextFillRect(context,rect);
            }
            
            JZCommitDataModel *firstDayOfWeek = [week firstObject];
            NSDateComponents *firstDayComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [firstDayOfWeek date]];
            if ([self isFirstWeekOfMonth: [firstDayComponents day]])
            {
                NSString* monthName = [self monthName:[firstDayOfWeek.month intValue]];
                // Setup the font specific variables
                NSDictionary *attributes = @{
                                             NSFontAttributeName   : [UIFont fontWithName:@"Helvetica" size:8],
                                             NSStrokeWidthAttributeName    : @(0),
                                             NSForegroundColorAttributeName    : [UIColor whiteColor]
                                             };
                // Draw text with CGPoint and attributes
                [monthName drawAtPoint:CGPointMake(self.frame.size.width - weekFromNow * 12 - 24 + 1,8 * 12 - 6) withAttributes:attributes];
            }
        }
        
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.image = im;
    }
    
}

- (NSString *)monthName:(int)month
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    return [array objectAtIndex:month - 1];
}

- (BOOL)isFirstWeekOfMonth:(NSInteger)day
{
    return day <= 7;
}

@end
