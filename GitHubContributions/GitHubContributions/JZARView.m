//
//  JZARView.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/9/3.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZARView.h"

@implementation JZARView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.antialiasingMode = SCNAntialiasingModeMultisampling4X;
    self.automaticallyUpdatesLighting = YES;
    self.preferredFramesPerSecond = 60;
    SCNCamera *cam = self.pointOfView.camera;
    cam.wantsHDR = YES;
    cam.wantsExposureAdaptation = YES;
    cam.exposureOffset = -1;
    cam.minimumExposure = -1;
    cam.maximumExposure = 3;
    cam.bloomIntensity = 0.5;
    
    return self;
}


@end
