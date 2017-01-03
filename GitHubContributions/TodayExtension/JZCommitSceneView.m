//
//  JZCommitSceneView.m
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/12.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZCommitSceneView.h"
#import "JZCommitManager.h"
#import "JZCommitDataModel.h"
#import "JZDataVisualizationManager.h"

@implementation JZCommitSceneView

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder]))
    {
        self.backgroundColor = [UIColor clearColor];
        [self initScene];
    }
    return self;
}

- (void)initScene
{
    
}

- (void)layerWillDraw:(CALayer *)layer {
    [super layerWillDraw:layer];
    layer.contentsFormat = kCAContentsFormatRGBA8Uint;
}

- (void)refreshData
{
    self.scene = [[JZDataVisualizationManager sharedManager] commitSceneWithRect:self.frame OS:JZDataVisualizationOSType_iOS_Widget];
    
    if (self.scene)
    {
        for (SCNNode *node in self.scene.rootNode.childNodes )
        {
            if ([node.name isEqualToString:@"cameraNode"])
            {
                self.pointOfView = node;
                
            }
        }
    }
    
}
@end
