//
//  JZARViewController.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/9/2.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZARViewController.h"
#import <Masonry/Masonry.h>
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
    
    
    self.arScene = [SCNScene scene];
    self.arSession = [[ARSession alloc] init];
    
    [self.arSession runWithConfiguration:conf options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
    
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
    self.arView.showsStatistics = true;
    self.arView.session = self.arSession;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
