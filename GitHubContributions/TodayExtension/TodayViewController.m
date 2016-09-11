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

#import "JZCommitManager.h"

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet JZCommitImageView *commitImageView;
@property (weak, nonatomic) IBOutlet JZCommitSceneView *commitSceneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitImageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitSceneViewTopCinstraint;

@end

@implementation TodayViewController

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    
    [[JZCommitManager sharedManager] refresh];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSMutableArray *weeks = [[JZCommitManager sharedManager] getCommits];
    [_commitSceneView refreshFromCommits:weeks];
    [_commitImageView refreshFromCommits:weeks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - UI

#pragma mark - NCWidgetProviding
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = maxSize;
        _commitSceneViewTopCinstraint.constant = 0.0f;
        [UIView animateWithDuration:0.2
                         animations:^{
                             _commitImageView.alpha = 1.0f;
                             _commitSceneView.alpha = 0.0f;
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
    else {
        self.preferredContentSize = CGSizeMake(0, 200.0);
        _commitSceneViewTopCinstraint.constant = - 115.0f;
        [UIView animateWithDuration:0.2
                         animations:^{
                             _commitImageView.alpha = 0.0f;
                             _commitSceneView.alpha = 1.0f;
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}
@end
