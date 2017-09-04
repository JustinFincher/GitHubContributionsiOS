//
//  JZARPlane.h
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/9/3.
//  Copyright © 2017年 JustZht. All rights reserved.
//

@import SceneKit;
@import ARKit;

@interface JZARPlane : SCNNode

- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor;
- (void)update:(ARPlaneAnchor *)anchor;
- (void)setTextureScale;
@property (nonatomic,retain) ARPlaneAnchor *anchor;
@property (nonatomic, retain) SCNPlane *planeGeometry;

@end
