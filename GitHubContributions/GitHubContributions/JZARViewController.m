//
//  JZARViewController.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/9/2.
//  Copyright © 2017年 JustZht. All rights reserved.
//
#import "JZDataVisualizationManager.h"
#import "JZARViewController.h"
#import <Masonry/Masonry.h>
#import "JZHeader.h"
#import "JZCommitDataModel.h"
@import ARKit;
@import SceneKit;

@interface JZARViewController ()<ARSCNViewDelegate>
@property (strong) ARSCNView* arView;
@property (strong) SCNScene * arScene;
@property (strong) ARSession* arSession;

@end

@implementation JZARViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    ARWorldTrackingConfiguration *conf = [[ARWorldTrackingConfiguration alloc] init];
    conf.lightEstimationEnabled = YES;
    conf.worldAlignment = ARWorldAlignmentGravityAndHeading;
    conf.planeDetection = ARPlaneDetectionHorizontal;
    
    self.arView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    self.arView.delegate = self;
    [self.view addSubview:self.arView];
    [self.arView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.center.mas_equalTo(self.view);
          make.width.mas_equalTo(self.view.mas_width);
          make.height.mas_equalTo(self.view.mas_height);
     }];
    self.arView.automaticallyUpdatesLighting = true;
//    self.arView.showsStatistics = true;
    
    self.arSession = [[ARSession alloc] init];
    [self.arSession runWithConfiguration:conf options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
    self.arView.session = self.arSession;
    
    self.arScene = [SCNScene scene];
//    self.arScene = [[JZDataVisualizationManager sharedManager] commitSceneWithRect:self.view.bounds OS:JZDataVisualizationOSType_iOS_Widget];
    self.arView.scene = self.arScene;
    
    
    self.arView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera
{
    NSLog(@"%ld",(long)camera.trackingState);
}
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor
{
    if ([anchor isKindOfClass: [ARPlaneAnchor class]])
    {
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        SCNBox *box = [SCNBox boxWithWidth:planeAnchor.extent.x height:0.005 length:planeAnchor.extent.z chamferRadius:0.0];
        box.firstMaterial.transparency = 0.1;
        SCNNode *node = [SCNNode nodeWithGeometry:box];
        node.position = SCNVector3Make(planeAnchor.center.x, -0.005, planeAnchor.center.z);
        
        [node addChildNode:[self commitNode]];
        
        return node;
    }else
    {
        return nil;
    }
}
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{}
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if ([anchor isKindOfClass: [ARPlaneAnchor class]])
    {
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        node.position = SCNVector3Make(planeAnchor.center.x, -0.005, planeAnchor.center.z);
        SCNBox *box = (SCNBox *)node.geometry;
        box.width = planeAnchor.extent.x;
        box.length = planeAnchor.extent.z;
        box.height = 0.005;
    }
}
- (void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{}


- (SCNNode *)commitNode
{
    float resize = 0.002;
    SCNNode *barNode = [SCNNode node];
    NSMutableArray *weeks;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        weeks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (weeks)
        {
            NSUInteger count = weeks.count;
            for (int weekFromNow = 0; weekFromNow < count; weekFromNow ++)
            {
                NSMutableArray *week = [weeks objectAtIndex:weekFromNow];
                for (JZCommitDataModel *day in week)
                {
                    SCNBox *box= [SCNBox boxWithWidth:1*resize height:([day.dataCount intValue] + 1)*resize length:1*resize chamferRadius:0.0f];
                    SCNNode *node = [SCNNode nodeWithGeometry:box];
                    SCNMaterial *mat = [SCNMaterial material];
                    box.materials = @[mat];
                    mat.diffuse.contents = day.color;
                    node.position = SCNVector3Make(-weekFromNow * 1.5*resize, box.height / 2.0, day.weekDay.intValue * 1.5*resize);
                    [barNode addChildNode:node];
                }
            }
        }
    }
    return barNode;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
