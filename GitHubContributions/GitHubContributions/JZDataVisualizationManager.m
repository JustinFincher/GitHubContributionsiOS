//
//  JZDataVisualizationManager.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/3.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZDataVisualizationManager.h"
#import "JZHeader.h"
#import "JZCommitDataModel.h"

#define COMMIT_IMAGE_RIGHT_MARGIN 4.0f
#define COMMIT_IMAGE_LEFT_MARGIN 4.0f
#define COMMIT_VERTIAL_TILE_NUM 8
#define COMMIT_TILE_SIZE_PERCETAGE 0.85f
#define COMMIT_FONT_SIZE_PERCETAGE 0.6f
#define WEEKS_IN_YEAR 52

@implementation JZDataVisualizationManager



#pragma mark Singleton Methods

+ (id)sharedManager {
    static JZDataVisualizationManager *sharedMyManager = nil;
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

#pragma mark - Visual Stuff

- (UIImage *)commitImageWithRect:(CGRect)rect
                              OS:(JZDataVisualizationOSType)osType
{
    
    float topMargin = (osType == JZDataVisualizationOsType_watchOS) ? 18.0f: 4.0f;
    float bottomMargin = (osType == JZDataVisualizationOsType_watchOS) ? 10.0f: 4.0f;
    NSMutableArray *weeks;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    UIImage* im = nil;
    if (data != nil)
    {
        weeks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (weeks)
        {
            @autoreleasepool
            {
                CGRect bounds = rect;
                UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
                switch (osType)
                {
                    case JZDataVisualizationOSType_iOS_Notification:
                    {
                        [[UIColor whiteColor] set];
                        UIRectFill(CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height));
                    }
                        break;
                    default:
                        [[UIColor clearColor] setFill];
                        break;
                }
                
                float squarenBlankSize = (bounds.size.height - topMargin - bottomMargin) / COMMIT_VERTIAL_TILE_NUM;
                float squareSize = squarenBlankSize * COMMIT_TILE_SIZE_PERCETAGE ;
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                int frameWidth = bounds.size.width - COMMIT_IMAGE_LEFT_MARGIN - COMMIT_IMAGE_RIGHT_MARGIN;
                int width =  (int)(frameWidth / squarenBlankSize);
                width = (width >= WEEKS_IN_YEAR) ? WEEKS_IN_YEAR - 1 : width;
                for (int weekFromNow = 0; weekFromNow < width; weekFromNow ++)
                {
                    NSMutableArray *week = [weeks objectAtIndex:weekFromNow];
                    for (JZCommitDataModel *day in week)
                    {
                        CGRect rect = CGRectMake(bounds.size.width - COMMIT_IMAGE_RIGHT_MARGIN - (weekFromNow + 1
                                                                      ) * squarenBlankSize, topMargin + (day.weekDay.intValue - 1) * squarenBlankSize, squareSize, squareSize);
                        [day.color setFill];
                        CGContextFillRect(context,rect);
                    }
                    
                    
                    JZCommitDataModel *firstDayOfWeek = [week firstObject];
                    NSString* monthName = [self monthName:[firstDayOfWeek.month intValue]];
                    // Setup the font specific variables
                    
                    UIColor *fontColor;
                    switch (osType)
                    {
                        case JZDataVisualizationOSType_iOS_Notification:
                            fontColor = [UIColor blackColor];
                            break;
                        default:
                            fontColor = [UIColor whiteColor];
                            break;
                    }
                    NSDictionary *attributes = @{
                                                 NSFontAttributeName   : [UIFont systemFontOfSize:squarenBlankSize * COMMIT_FONT_SIZE_PERCETAGE],
                                                 NSStrokeWidthAttributeName    : @(0),
                                                 NSForegroundColorAttributeName    : fontColor
                                                 };
                    // Draw text with CGPoint and attributes
                    [monthName drawAtPoint:CGPointMake(bounds.size.width - COMMIT_IMAGE_RIGHT_MARGIN - (weekFromNow + 1) * squarenBlankSize + squarenBlankSize * (1.0f - COMMIT_FONT_SIZE_PERCETAGE)/2.0f ,topMargin + (COMMIT_VERTIAL_TILE_NUM - 1) * squarenBlankSize) withAttributes:attributes];
                }
                
                im = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

        }
    }
    return im;
}

- (NSString *)monthName:(int)month
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"J",@"F",@"M",@"A",@"M",@"J",@"J",@"A",@"S",@"O",@"N",@"D", nil];
    return [array objectAtIndex:month - 1];
}

- (SCNScene *)commitSceneWithRect:(CGRect)rect
                               OS:(JZDataVisualizationOSType)osType
{
    SCNScene * scene = [SCNScene scene];
    
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeDirectional;
    light.color = [UIColor colorWithWhite:1.0 alpha:0.2];
    light.shadowColor = (__bridge id _Nonnull)([UIColor colorWithWhite:0.0 alpha:0.8].CGColor);
    SCNNode *lightNode = [SCNNode node];
    lightNode.eulerAngles = SCNVector3Make(-M_PI / 3, M_PI_4 * 3,0);
    lightNode.light = light;
    [scene.rootNode addChildNode:lightNode];
    
    SCNLight *ambientLight = [SCNLight light];
    ambientLight.type = SCNLightTypeAmbient;
    ambientLight.color = [UIColor colorWithWhite:0.8 alpha:0.4];
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = ambientLight;
    [scene.rootNode addChildNode:ambientLightNode];
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.name = @"cameraNode";
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange= YES;
    cameraNode.camera.usesOrthographicProjection = YES;
    [scene.rootNode addChildNode:cameraNode];
    cameraNode.eulerAngles = SCNVector3Make(-M_PI / 6, +M_PI_4,0);
    
    
    SCNNode *barNode = [SCNNode node];
    barNode.name = @"barNode";
    barNode.position = SCNVector3Make(0, 0, 0);
    [scene.rootNode addChildNode:barNode];
    
    NSMutableArray *weeks;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        weeks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (weeks)
        {
            NSUInteger count;
            if (osType == JZDataVisualizationOsType_watchOS)
            {
                count = 10;
                cameraNode.camera.orthographicScale = 5.0f;
                cameraNode.position = SCNVector3Make(23, 23, 30);
            }else
            {
                count = weeks.count;
                cameraNode.camera.orthographicScale = 11 - (rect.size.width - 320)/80.0f;
                cameraNode.position = SCNVector3Make(M_PI_4 * 50 - 15 * 1.5f, M_PI / 6.0f * 50 + 2,  M_PI_4 * 50);
            }
            for (int weekFromNow = 0; weekFromNow < count; weekFromNow ++)
            {
                NSMutableArray *week = [weeks objectAtIndex:weekFromNow];
                for (JZCommitDataModel *day in week)
                {
                    SCNBox *box= [SCNBox boxWithWidth:1 height:([day.dataCount intValue] + 1) length:1 chamferRadius:0.0f];
                    SCNNode *node = [SCNNode nodeWithGeometry:box];
                    SCNMaterial *mat = [SCNMaterial material];
                    box.materials = @[mat];
                    mat.diffuse.contents = day.color;
                    node.position = SCNVector3Make(-weekFromNow * 1.5, box.height / 2.0, day.weekDay.intValue * 1.5);
                    [barNode addChildNode:node];
                }
            }
        }
    }
    
    return scene;
}



@end
