//
//  TodayViewController.m
//  TodayExtension
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "JZCommitImageView.h"
#import "JZCommitSceneView.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "JZCommitManager.h"
#import "JZHeader.h"

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet JZCommitImageView *commitImageView;
@property (weak, nonatomic) IBOutlet JZCommitSceneView *commitSceneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitImageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitSceneViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation TodayViewController

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [Fabric with:@[CrashlyticsKit]];
    }
    return self;
}
#pragma mark - UI
- (IBAction)goSettingsButtonPressed:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"com.JustZht.GitHubContributions://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.extensionContext.widgetActiveDisplayMode == NCWidgetDisplayModeCompact)
    {
        _commitImageView.alpha = 1.0f;
        _commitSceneView.alpha = 0.0f;
    }else
    {
        _commitImageView.alpha = 0.0f;
        _commitSceneView.alpha = 1.0f;
    }
    [_settingsButton setTitle:@"" forState:UIControlStateNormal];
    
    NSMutableArray *weeks;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        if (self.extensionContext.widgetActiveDisplayMode == NCWidgetDisplayModeCompact)
        {
            [_commitImageView refreshData];
        }else
        {
            [_commitSceneView refreshData];
        }
    }else
    {
        weeks = [[JZCommitManager sharedManager] refresh];
        if (!weeks)
        {
            [self showError];
            return;
        }
        if (self.extensionContext.widgetActiveDisplayMode == NCWidgetDisplayModeCompact)
        {
            [_commitImageView refreshData];
        }else
        {
            [_commitSceneView refreshData];
        }
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weeks] ;
        [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] setObject:data forKey:@"GitHubContributionsArray"];
        if ([[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] synchronize])
        {
            JZLog(@"viewWillAppearDataTaskNewData");
        }else
        {
            JZLog(@"viewWillAppearDataTakskFailed");
        }
        
    }
    
}

- (void)showError
{
    [_settingsButton setTitle:@"Tap to set username" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    if (self.extensionContext.widgetActiveDisplayMode == NCWidgetDisplayModeCompact)
    {
        _commitSceneView.scene = nil;
    }else
    {
        _commitImageView.image = nil;
    }
    [Answers logCustomEventWithName:@"com.JustZht.GitHubContributions.TodayExtension.MemoryWarning"
                   customAttributes:@{}];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}


#pragma mark - NCWidgetProviding
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = maxSize;
        _commitSceneViewTopConstraint.constant = -210.0f;
        [UIView animateWithDuration:0.1
                         animations:^{
                             _commitImageView.alpha = 1.0f;
                             _commitSceneView.alpha = 0.0f;
                             [self.view layoutIfNeeded]; // Called on parent view
                         } completion:^(BOOL finished)
         {
//             _commitSceneView.scene = nil;
             [_commitImageView refreshData];
         }];
    }
    else {
        self.preferredContentSize = CGSizeMake(0, 200.0);
        _commitSceneViewTopConstraint.constant = - 0.0;
        [UIView animateWithDuration:0.1
                         animations:^{
                             _commitImageView.alpha = 0.0f;
                             _commitSceneView.alpha = 1.0f;
                             [self.view layoutIfNeeded]; // Called on parent view
                         }completion:^(BOOL finished)
         {
//             _commitImageView.image = nil;
             [_commitSceneView refreshData];
         }];

    }
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

@end
