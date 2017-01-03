//
//  JZDataVisualizationManager.h
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/3.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface JZDataVisualizationManager : NSObject

typedef NS_ENUM(NSInteger, JZDataVisualizationOSType) {
    JZDataVisualizationOSType_iOS_Widget,
    JZDataVisualizationOSType_iOS_Notification,
    JZDataVisualizationOsType_watchOS
};

+ (id)sharedManager;

- (UIImage *)commitImageWithRect:(CGRect)rect
                              OS:(JZDataVisualizationOSType)osType;
- (SCNScene *)commitSceneWithRect:(CGRect)rect
                               OS:(JZDataVisualizationOSType)osType;


@end
