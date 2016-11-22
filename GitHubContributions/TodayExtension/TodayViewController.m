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
#pragma mark - UI
- (IBAction)goSettingsButtonPressed:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"com.JustZht.GitHubContributions://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    _settingsButton.hidden = YES;
    
//     [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] removeObjectForKey:@"GitHubContributionsArray"];
//     [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] removeObjectForKey:@"GitHubContributionsName"];
    
    NSMutableArray *weeks;
    NSData *data = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"]  objectForKey:@"GitHubContributionsArray"];
    if (data != nil)
    {
        weeks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (!weeks)
        {
            NSLog(@"NSUserDefaults DO NOT HAVE weeks DATA");
        }else
        {
            NSLog(@"NSUserDefaults DO HAVE weeks DATA");
            [_commitSceneView refreshFromCommits:weeks];
            [_commitImageView refreshFromCommits:weeks];
        }
    }else
    {
        NSLog(@"NSUserDefaults DO NOT HAVE DATA");
         weeks = [[JZCommitManager sharedManager] refresh];
        if (!weeks)
        {
            [self showError];
            return;
        }
        [_commitSceneView refreshFromCommits:weeks];
        [_commitImageView refreshFromCommits:weeks];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weeks] ;
        [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] setObject:data forKey:@"GitHubContributionsArray"];
        if ([[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] synchronize])
        {
            NSLog(@"viewWillAppearDataTaskNewData");
        }else
        {
            NSLog(@"viewWillAppearDataTakskFailed");
        }
        
    }
}

- (void)showError
{
    _settingsButton.hidden = NO;
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


#pragma mark - NCWidgetProviding
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = maxSize;
        _commitSceneViewTopConstraint.constant = -210.0f;
        [UIView animateWithDuration:0.2
                         animations:^{
                             _commitImageView.alpha = 1.0f;
                             _commitSceneView.alpha = 0.0f;
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
    else {
        self.preferredContentSize = CGSizeMake(0, 200.0);
        _commitSceneViewTopConstraint.constant = - 0.0;
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
