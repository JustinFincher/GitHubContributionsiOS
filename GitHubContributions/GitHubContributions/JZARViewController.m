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
#import "JZARView.h"
#import "JZCommitDataModel.h"
#import "MaterialSnackbar.h"
#import "JZARPlane.h"
@import ARKit;
@import SceneKit;

@interface JZARViewController ()<ARSCNViewDelegate>
@property (strong) ARSCNView* arView;
@property (strong) SCNScene * arScene;
@property (strong) ARSession* arSession;

@property (strong) UIVisualEffectView *effectView;
@property (strong) UIButton *backButton;

@property (strong) NSMutableDictionary *planes;


@property (nonatomic) BOOL hasPlaneDetected;

@end

@implementation JZARViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hasPlaneDetected = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arView = [[JZARView alloc] initWithFrame:self.view.bounds];
    self.arView.delegate = self;
    [self.view addSubview:self.arView];
    [self.arView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.center.mas_equalTo(self.view);
          make.width.mas_equalTo(self.view.mas_width);
          make.height.mas_equalTo(self.view.mas_height);
     }];
    
   
    self.arSession = [[ARSession alloc] init];
    self.arView.session = self.arSession;
    
    self.arScene = [SCNScene scene];
    self.arView.scene = self.arScene;
    self.arView.autoenablesDefaultLighting = YES;
//    self.arView.debugOptions = ARSCNDebugOptionShowWorldOrigin | ARSCNDebugOptionShowFeaturePoints;
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.backButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.backButton setTintColor:[UIColor whiteColor]];
    [self.backButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.arView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.mas_equalTo(self.arView.mas_left);
         make.top.mas_equalTo(self.arView.mas_top);
         make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.1);
         make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.1);
     }];
}
- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    ARWorldTrackingConfiguration *conf = [[ARWorldTrackingConfiguration alloc] init];
    conf.lightEstimationEnabled = YES;
    conf.worldAlignment = ARWorldAlignmentGravity;
    conf.planeDetection = ARPlaneDetectionHorizontal;
    
    [self.arSession runWithConfiguration:conf options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.arSession pause];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ARSessionObserver
- (void)session:(ARSession *)session cameraDidChangeTrackingState:(ARCamera *)camera
{
    NSLog(@"%@",[self trackStateString:camera.trackingState]);
    
    if (camera.trackingStateReason != ARTrackingStateReasonNone)
    {
        MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
        switch (camera.trackingStateReason) {
            case ARTrackingStateReasonInitializing:
                message.text = [NSString stringWithFormat:@"AR Mode Initializing"];
                break;
            case ARTrackingStateReasonExcessiveMotion:
                message.text = [NSString stringWithFormat:@"Please Slow Down"];
                break;
            case ARTrackingStateReasonInsufficientFeatures:
                message.text = [NSString stringWithFormat:@"Please Find A Plane"];
                break;
            default:
                break;
        }
        [MDCSnackbarManager showMessage:message];
    }
   
}
- (void)sessionWasInterrupted:(ARSession *)session
{
    
}
- (void)sessionInterruptionEnded:(ARSession *)session
{
    
}
- (void)session:(ARSession *)session didFailWithError:(NSError *)error
{
    
}

#pragma mark -
//- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor
//{
//    return nil;
//}
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }
    JZARPlane *plane = [[JZARPlane alloc] initWithAnchor: (ARPlaneAnchor *)anchor];
    [self.planes setObject:plane forKey:anchor.identifier];
    [node addChildNode:plane];
    
    
    [plane addChildNode:[self commitNode]];
    self.hasPlaneDetected = YES;
    
    ARWorldTrackingConfiguration *conf = [[ARWorldTrackingConfiguration alloc] init];
    conf.lightEstimationEnabled = YES;
    conf.worldAlignment = ARWorldAlignmentGravity;
    conf.planeDetection = ARPlaneDetectionNone;
    
    [self.arSession runWithConfiguration:conf options:0];
    
}
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    JZARPlane *plane = [self.planes objectForKey:anchor.identifier];
    if (plane == nil) {
        return;
    }
    [plane update:(ARPlaneAnchor *)anchor];
}
- (void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    [self.planes removeObjectForKey:anchor.identifier];
    self.hasPlaneDetected = NO;
}


- (SCNNode *)commitNode
{
    float resize = 0.004;
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

- (NSString*)trackStateString:(ARTrackingState)formatType
{
    NSString *result = nil;
    
    switch(formatType) {
        case ARTrackingStateNotAvailable:
            result = @"NotAvailable";
            break;
        case ARTrackingStateLimited:
            result = @"Limited";
            break;
        case ARTrackingStateNormal:
            result = @"Normal";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
}

@end
