//
//  JZCommitSceneInterfaceController.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZCommitSceneInterfaceController.h"
#import "JZCommitDataModel.h"
#import "JZHeader.h"

@interface JZCommitSceneInterfaceController ()<WKCrownDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceSCNScene *sceneView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *noDataLabel;
@property float barHeightScale;

@end

@implementation JZCommitSceneInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    self.crownSequencer.delegate = self;
    self.barHeightScale = 0.5f;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"JZ_WATCH_USERDEFAULT_UPDATED" object:nil];
}
- (void)willDisappear
{
    [[self crownSequencer] resignFocus];
}
- (void)didAppear
{
    [[self crownSequencer] focus];
}

- (void)willActivate
{
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    [self refreshView];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)refreshView
{
    self.sceneView.scene = [SCNScene scene];
    
    //    self.sceneView.autoenablesDefaultLighting = YES;
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeDirectional;
    light.color = [UIColor colorWithWhite:1.0 alpha:0.2];
    light.shadowColor = (__bridge id _Nonnull)([UIColor colorWithWhite:0.0 alpha:0.8].CGColor);
    SCNNode *lightNode = [SCNNode node];
    lightNode.eulerAngles = SCNVector3Make(-M_PI / 3, M_PI_4 * 3,0);
    lightNode.light = light;
    [self.sceneView.scene.rootNode addChildNode:lightNode];
    
    SCNLight *ambientLight = [SCNLight light];
    ambientLight.type = SCNLightTypeAmbient;
    ambientLight.color = [UIColor colorWithWhite:0.8 alpha:0.4];
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = ambientLight;
    [self.sceneView.scene.rootNode addChildNode:ambientLightNode];
    
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange= YES;
    cameraNode.camera.usesOrthographicProjection = YES;
    cameraNode.camera.orthographicScale = 5.0f;
    
    [self.sceneView.scene.rootNode addChildNode:cameraNode];
    cameraNode.position = SCNVector3Make(23, 23, 30);
    cameraNode.eulerAngles = SCNVector3Make(-M_PI / 6, +M_PI_4,0);
    self.sceneView.pointOfView = cameraNode;
    
    
    SCNNode *barNode = [SCNNode node];
    barNode.name = @"barNode";
    [self.sceneView.scene.rootNode addChildNode:barNode];
    
    NSMutableArray *weeks;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        weeks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!weeks)
        {
            JZLog(@"NSUserDefaults DO NOT HAVE weeks DATA");
            [self.noDataLabel setHidden:NO];
        }else
        {
            JZLog(@"NSUserDefaults DO HAVE weeks DATA");
            [self.noDataLabel setHidden:YES];
            for (int weekFromNow = 0; weekFromNow < 10; weekFromNow ++)
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
    }else
    {
        [self.noDataLabel setHidden:NO];
    }
    [self refreshBarNode];

}

- (void)refreshBarNode
{
    if (self.sceneView && self.sceneView.scene)
    {
        for (SCNNode *node in self.sceneView.scene.rootNode.childNodes )
        {
            if ([node.name isEqualToString:@"barNode"])
            {
                node.scale = SCNVector3Make(1, self.barHeightScale, 1);
            }
        }
    }
}

#pragma mark - WKCrownDelegate
- (void)crownDidRotate:(WKCrownSequencer *)crownSequencer rotationalDelta:(double)rotationalDelta
{
    if ((rotationalDelta < 0))
    {
        if (self.barHeightScale - 0.01f >= 0.02f)
        {
            self.barHeightScale -= 0.01f;
//            [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeDirectionUp];

        }else
        {
            self.barHeightScale = 0.02f;
            [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeDirectionUp];
        }
    }else
    {
        if (self.barHeightScale + 0.01f <= 2.0f)
        {
            self.barHeightScale += 0.01f;
//            [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeDirectionDown];
        }else
        {
            self.barHeightScale = 2.0f;
            [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeDirectionDown];
        }
    }
    
    [self refreshBarNode];
}
@end



