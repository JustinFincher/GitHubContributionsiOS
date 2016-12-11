//
//  ViewController.m
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "ViewController.h"
#import "JZCommitManager.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "JZHeader.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIButton *updateInfoButton;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [_updateInfoButton setTitle:@"Update Info" forState:UIControlStateNormal];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.userNameField.delegate = self;
    
    NSString *name = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] objectForKey:@"GitHubContributionsName"];
    if (name)
    {
        _userNameField.text = name;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateInfoButtonPressed:(id)sender
{
    NSString *trimmedName = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] setObject:trimmedName forKey:@"GitHubContributionsName"];
    
    UIButton *button = (UIButton *)sender;
    
    [button setTitle:@"Widget & Complication will update soon" forState:UIControlStateNormal];
    
    dispatch_queue_t gqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(gqueue, ^(void)
    {
        NSMutableArray * array = [[JZCommitManager sharedManager] refresh];
        if (array)
        {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array] ;
            
            [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] setObject:data forKey:@"GitHubContributionsArray"];
            WCSession* session = [WCSession defaultSession];
            if ([session activationState] != WCSessionActivationStateActivated)
            {
                [session activateSession];
            }else
            {
                if ([session isReachable])
                {
                    [session sendMessage:[[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] dictionaryRepresentation] replyHandler:nil errorHandler:^(NSError *error)
                     {
                         JZLog(@"%@",[error localizedDescription]);
                     }];
                }
                [session transferUserInfo:[[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] dictionaryRepresentation]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                           {
                               [button setTitle:@"In the mean time, you can close this app" forState:UIControlStateNormal];
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                                              {
                                                  [button setTitle:@"Update Info" forState:UIControlStateNormal];
                                              });
                           });
        });
    });
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    return YES;
}
@end
