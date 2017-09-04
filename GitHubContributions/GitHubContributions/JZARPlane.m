//
//  JZARPlane.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/9/3.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZARPlane.h"

#define GRID_SIZE 5

@implementation JZARPlane

- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor {
    self = [super init];
    
    self.anchor = anchor;
    self.planeGeometry = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
    
    // Instead of just visualizing the grid as a gray plane, we will render
    // it in some Tron style colours.
    SCNMaterial *material = [SCNMaterial new];
    UIImage *img = [UIImage imageNamed:@"grid"];
    material.diffuse.contents = img;
    material.transparency = 0.2;
    self.planeGeometry.materials = @[material];
    
    SCNNode *planeNode = [SCNNode nodeWithGeometry:self.planeGeometry];
    planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    
    // Planes in SceneKit are vertical by default so we need to rotate 90degrees to match
    // planes in ARKit
    planeNode.transform = SCNMatrix4MakeRotation(-M_PI / 2.0, 1.0, 0.0, 0.0);
    
    [self setTextureScale];
    [self addChildNode:planeNode];
    return self;
}

- (void)update:(ARPlaneAnchor *)anchor {
    // As the user moves around the extend and location of the plane
    // may be updated. We need to update our 3D geometry to match the
    // new parameters of the plane.
    self.planeGeometry.width = anchor.extent.x;
    self.planeGeometry.height = anchor.extent.z;
    
    // When the plane is first created it's center is 0,0,0 and the nodes
    // transform contains the translation parameters. As the plane is updated
    // the planes translation remains the same but it's center is updated so
    // we need to update the 3D geometry position
    self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    [self setTextureScale];
}

- (void)setTextureScale {
    CGFloat width = self.planeGeometry.width * GRID_SIZE;
    CGFloat height = self.planeGeometry.height * GRID_SIZE;
    
    // As the width/height of the plane updates, we want our tron grid material to
    // cover the entire plane, repeating the texture over and over. Also if the
    // grid is less than 1 unit, we don't want to squash the texture to fit, so
    // scaling updates the texture co-ordinates to crop the texture in that case
    SCNMaterial *material = self.planeGeometry.materials.firstObject;
    material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1);
    material.diffuse.wrapS = SCNWrapModeRepeat;
    material.diffuse.wrapT = SCNWrapModeRepeat;
}
@end
