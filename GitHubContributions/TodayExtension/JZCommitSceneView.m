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

- (void)refreshFromCommits:(NSMutableArray *)array
{
    self.scene = [SCNScene scene];
    
    self.autoenablesDefaultLighting = YES;
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange= YES;
    cameraNode.camera.usesOrthographicProjection = YES;
    cameraNode.camera.orthographicScale = 12.0;
    [self.scene.rootNode addChildNode:cameraNode];
    cameraNode.position = SCNVector3Make(-9, 15, 20);
    cameraNode.eulerAngles = SCNVector3Make(-M_PI_4, +M_PI_4,0);
    
    self.pointOfView = cameraNode;
    
    for (int weekFromNow = 0; weekFromNow < 32; weekFromNow ++)
    {
        NSMutableArray *week = [array objectAtIndex:weekFromNow];
        for (JZCommitDataModel *day in week)
        {
            SCNBox *box= [SCNBox boxWithWidth:1 height:[day.dataCount intValue] + 1 length:1 chamferRadius:0.0f];
            SCNNode *node = [SCNNode nodeWithGeometry:box];
            SCNMaterial *mat = [SCNMaterial material];
            box.materials = @[mat];
            mat.diffuse.contents = day.color;
            node.position = SCNVector3Make(-weekFromNow * 1.5, box.height / 2.0, day.weekDay.intValue * 1.5);
            [self.scene.rootNode addChildNode:node];
        }
    }

}
@end
