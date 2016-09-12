//
//  ViewController.m
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "ViewController.h"
#import "JZCommitManager.h"

@interface ViewController ()
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
    
    
    NSString *name = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] objectForKey:@"GitHubContributionsName"];
    if (name)
    {
        _userNameField.text = name;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateInfoButtonPressed:(id)sender
{
    NSString *trimmedName = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] setObject:trimmedName forKey:@"GitHubContributionsName"];
    
    UIButton *button = (UIButton *)sender;
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.JustZht.GitHubContributions"] removeObjectForKey:@"GitHubContributionsArray"];
    
    [button setTitle:@"Widget will update soon" forState:UIControlStateNormal];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
