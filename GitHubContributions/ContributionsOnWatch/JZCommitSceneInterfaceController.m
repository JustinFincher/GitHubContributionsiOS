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
#import "JZDataVisualizationManager.h"

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
    self.sceneView.scene = [[JZDataVisualizationManager sharedManager] commitSceneWithRect:[[WKInterfaceDevice currentDevice] screenBounds] OS:JZDataVisualizationOsType_watchOS];
    
    if (self.sceneView.scene)
    {
        for (SCNNode *node in self.sceneView.scene.rootNode.childNodes )
        {
            if ([node.name isEqualToString:@"cameraNode"])
            {
                self.sceneView.pointOfView = node;
                
            }
        }
    }
    
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
         [self.noDataLabel setHidden:YES];
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
        }else
        {
            self.barHeightScale = 2.0f;
            [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeDirectionDown];
        }
    }
    
    [self refreshBarNode];
}
@end



