//
//  JZIntroViewController.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/4.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZIntroViewController.h"
#import <Masonry/Masonry.h>
#import "JZHeader.h"

@interface JZIntroViewController ()

@property (nonatomic,strong) UIVisualEffectView *effectContainerView;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *iconLabel;

@end

@implementation JZIntroViewController

- (NSUInteger)numberOfPages
{
    return 5;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    [self configureAnimations];
}

- (void)configureViews
{
    
    self.effectContainerView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.contentView addSubview:self.effectContainerView];
    [self.effectContainerView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.mas_equalTo(self.contentView.mas_bottom);
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.view.mas_width);
         make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.1);
     }];
    [self keepView:self.effectContainerView onPages:@[@(0),@(1),@(2)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [self.effectContainerView addSubview:self.pageControl];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.center.mas_equalTo(self.effectContainerView);
     }];
    
    
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_icon"]];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.25);
    }];
    [self keepView:self.iconImageView onPages:@[@(0)] atTimes:@[@(0)]];
    
    self.iconLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.iconLabel.text = @"CONTRIBUTIONS";
    self.iconLabel.font = [UIFont fontWithName:@"Avenir-Light" size:20];
    self.iconLabel.textAlignment = NSTextAlignmentCenter;
    self.iconLabel.textColor = UIColorFromRGB(0x676767);
    [self.contentView addSubview:self.iconLabel];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.5);
     }];
    [self keepView:self.iconLabel onPages:@[@(0)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
}

- (void)configureAnimations
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
