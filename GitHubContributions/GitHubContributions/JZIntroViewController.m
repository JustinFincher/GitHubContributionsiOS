//
//  JZIntroViewController.m
//  GitHubContributions
//
//  Created by Justin Fincher on 2017/1/4.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "JZIntroViewController.h"
#import <Masonry/Masonry.h>
#import "JZCommitManager.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "JZHeader.h"
#import <UserNotifications/UserNotifications.h>
#import <Shimmer/FBShimmeringView.h>
#import "JZNotificationManager.h"
#import "JZDataVisualizationManager.h"

#define INTRO_TOTAL_PAGE_NUM 7

@interface JZIntroViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIVisualEffectView *effectContainerView;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *iconLabel;
@property (nonatomic,strong) FBShimmeringView *setupLabelContainerView;
@property (nonatomic,strong) UILabel *setupLabel;

@property (nonatomic,strong) UIImageView *githubIdImageView;
@property (nonatomic,strong) UILabel *githubIdFindLabel;
@property (nonatomic,strong) UILabel *githubIdInputNoticeLabel;
@property (nonatomic,strong) UITextField *githubIdInputField;

@property (nonatomic,strong) UIImageView *phoneBodyImageView;
@property (nonatomic,strong) UIView *phoneScreenMaskView;

@property (nonatomic,strong) UILabel *phoneScreenTodayUnAddedLabel;
@property (nonatomic,strong) UILabel *phoneScreenTodayAddingLabel;
@property (nonatomic,strong) UILabel *phoneScreenTodayAddedLabel;

@property (nonatomic,strong) UIImageView *phoneScreenTodayUnAddedImageView;
@property (nonatomic,strong) UIImageView *phoneScreenTodayAddingImageView;
@property (nonatomic,strong) UIImageView *phoneScreenTodayAddedImageView;

@property (nonatomic,strong) UIImageView *notificationImageView;
@property (nonatomic,strong) UILabel *notificationLabel;
@property (nonatomic,strong) UISwitch *notificationSwitch;

@property (nonatomic,strong) UIImageView *watchImageView;
@property (nonatomic,strong) UILabel *watchLabel;


@end

@implementation JZIntroViewController

- (NSUInteger)numberOfPages
{
    return INTRO_TOTAL_PAGE_NUM;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        static NSInteger previousPage = 0;
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        if (previousPage != page)
        {
            self.pageControl.currentPage = page;
            previousPage = page;
        }
    }
}

#pragma mark - UIUIUI
- (void)configureViews
{
    self.scrollView.delegate = self;
    
    
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_icon"]];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.25);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.2);
        make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.2);
    }];
    [self keepView:self.iconImageView onPages:@[@(0)] atTimes:@[@(0)]];
    
    self.iconLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.iconLabel.text = @"CONTRIBUTIONS";
    self.iconLabel.minimumScaleFactor = 0.1;
    self.iconLabel.adjustsFontSizeToFitWidth = YES;
    self.iconLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.iconLabel.textAlignment = NSTextAlignmentCenter;
    self.iconLabel.textColor = UIColorFromRGB(0x676767);
    [self.contentView addSubview:self.iconLabel];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.45);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.22);
     }];
    [self keepView:self.iconLabel onPages:@[@(0)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.setupLabelContainerView = [[FBShimmeringView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.setupLabelContainerView];
    [self.setupLabelContainerView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.75);
        make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.9);
    }];
    self.setupLabelContainerView.shimmering = YES;
    [self keepView:self.setupLabelContainerView onPages:@[@(0)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.setupLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    if (![[JZCommitManager sharedManager] haveUserID])
    {
        self.setupLabel.text = @"SETUP";
    }else
    {
        self.setupLabel.text = @"SETTINGS";
    }
    self.setupLabel.userInteractionEnabled = YES;
    self.setupLabel.minimumScaleFactor = 0.1;
    self.setupLabel.adjustsFontSizeToFitWidth = YES;
    self.setupLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.setupLabel.textAlignment = NSTextAlignmentCenter;
    self.setupLabel.textColor = UIColorFromRGB(0x676767);
    UITapGestureRecognizer *setupLabelTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(showUserIDPage)];
    [self.setupLabel addGestureRecognizer:setupLabelTapGesture];
    [self.setupLabelContainerView addSubview:self.setupLabel];
    [self.setupLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.center.mas_equalTo(self.setupLabelContainerView);
    }];
    self.setupLabelContainerView.contentView = self.setupLabel;
    self.setupLabelContainerView.shimmeringBeginFadeDuration = 0.3;
    self.setupLabelContainerView.shimmeringSpeed = 50;
    self.setupLabelContainerView.shimmeringOpacity = 0.3;
    self.setupLabelContainerView.shimmeringAnimationOpacity = 1.0f;

    
    self.githubIdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_github_id_screenshot"]];
    [self.contentView addSubview:self.githubIdImageView];
    [self.githubIdImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5);
        make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self keepView:self.githubIdImageView onPages:@[@(1)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.githubIdFindLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.githubIdFindLabel];
    self.githubIdFindLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.githubIdFindLabel.numberOfLines = 3;
    self.githubIdFindLabel.adjustsFontSizeToFitWidth = YES;
    self.githubIdFindLabel.minimumScaleFactor = 0.1;
    self.githubIdFindLabel.textColor = UIColorFromRGB(0x676767);
    self.githubIdFindLabel.textAlignment = NSTextAlignmentCenter;
    self.githubIdFindLabel.text = @"DON'T KNOW YOUR GITHUB ID? GO TO YOUR GITHUB PROFILE AND FIND YOUR ID BY URL";
    [self.githubIdFindLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.45);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.4);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.55);
     }];
    [self keepView:self.githubIdFindLabel onPages:@[@(1)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];

    self.githubIdInputNoticeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.githubIdInputNoticeLabel];
    self.githubIdInputNoticeLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.githubIdInputNoticeLabel.adjustsFontSizeToFitWidth = YES;
    self.githubIdInputNoticeLabel.textColor = UIColorFromRGB(0x676767);
    self.githubIdInputNoticeLabel.textAlignment = NSTextAlignmentCenter;
    self.githubIdInputNoticeLabel.text = @"INPUT YOUR GITHUB ID";
    [self.githubIdInputNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.05);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.15);
     }];
    [self keepView:self.githubIdInputNoticeLabel onPages:@[@(1)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];

    self.githubIdInputField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.githubIdInputField];
    NSString *name = [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] objectForKey:@"GitHubContributionsName"];
    if (name)
    {
        self.githubIdInputField.text = name;
    }
    self.githubIdInputField.delegate = self;
    self.githubIdInputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.githubIdInputField.font = [UIFont fontWithName:@"Avenir-Medium" size:30];
    self.githubIdInputField.adjustsFontSizeToFitWidth = YES;
    self.githubIdInputField.minimumFontSize = 0.02;
    self.githubIdInputField.textColor = UIColorFromRGB(0x272727);
    self.githubIdInputField.placeholder = @"YOUR ID";
    self.githubIdInputField.textAlignment = NSTextAlignmentCenter;
    [self.githubIdInputField mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.20);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.25);
     }];
    [self keepView:self.githubIdInputField onPages:@[@(1)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.notificationSwitch addTarget:self action:@selector(notificationSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.notificationSwitch setOn:[[JZNotificationManager sharedManager] isNotificationEnabled]];
    [self.contentView addSubview:self.notificationSwitch];
    [self.notificationSwitch mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.5);
     }];
    [self keepView:self.notificationSwitch onPages:@[@(2),@(3),@(4),@(5)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    IFTTTAlphaAnimation *notificationSwitchAlphaAnimation = [[IFTTTAlphaAnimation alloc] initWithView:self.notificationSwitch];
    [notificationSwitchAlphaAnimation addKeyframeForTime:4 alpha:0];
    [notificationSwitchAlphaAnimation addKeyframeForTime:5 alpha:1];
    [notificationSwitchAlphaAnimation addKeyframeForTime:6 alpha:0];
    [self.animator addAnimation:notificationSwitchAlphaAnimation];
    
    
    self.phoneBodyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_iphone_screen_blend"]];
    [self.contentView addSubview:self.phoneBodyImageView];
    [self.phoneBodyImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.9);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5623*0.9);
     }];
    [self keepView:self.phoneBodyImageView onPages:@[@(2),@(3),@(4),@(5)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    NSLayoutConstraint *phoneBodyImageViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.phoneBodyImageView
                                                                                          attribute:NSLayoutAttributeCenterY
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:self.contentView
                                                                                          attribute:NSLayoutAttributeTop
                                                                                         multiplier:1.0f constant:0.f];
    [self.contentView addConstraint:phoneBodyImageViewTopConstraint];
    IFTTTConstraintMultiplierAnimation *phoneBodyImageViewTopConstraintMultiplierAnimation = [IFTTTConstraintMultiplierAnimation animationWithSuperview:self.contentView
                                                                                                                                                constraint:phoneBodyImageViewTopConstraint
                                                                                                                                                 attribute:IFTTTLayoutAttributeHeight
                                                                                                                                             referenceView:self.contentView];
    [phoneBodyImageViewTopConstraintMultiplierAnimation addKeyframeForTime:4 multiplier:0.9f withEasingFunction:IFTTTEasingFunctionEaseOutCubic];
    [phoneBodyImageViewTopConstraintMultiplierAnimation addKeyframeForTime:5 multiplier:1.03f];
    [phoneBodyImageViewTopConstraintMultiplierAnimation addKeyframeForTime:6 multiplier:1.6f];
    [self.animator addAnimation:phoneBodyImageViewTopConstraintMultiplierAnimation];
    
    
    self.phoneScreenMaskView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.phoneBodyImageView addSubview:self.phoneScreenMaskView];
    [self.phoneScreenMaskView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.center.mas_equalTo(self.phoneBodyImageView);
        make.size.mas_equalTo(self.phoneBodyImageView).multipliedBy(0.7136);
    }];
    self.phoneScreenMaskView.backgroundColor = [UIColor blackColor];
    self.phoneScreenMaskView.layer.masksToBounds = YES;
    
    
    self.phoneScreenTodayUnAddedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneScreenTodayUnAdded"]];
    [self.phoneScreenMaskView addSubview:self.phoneScreenTodayUnAddedImageView];
    [self.phoneScreenTodayUnAddedImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.center.mas_equalTo(self.phoneScreenMaskView);
         make.size.mas_equalTo(self.phoneScreenMaskView);
     }];
    
    self.phoneScreenTodayAddedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneScreenTodayAdded"]];
    [self.phoneScreenMaskView addSubview:self.phoneScreenTodayAddedImageView];
    [self.phoneScreenTodayAddedImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.center.mas_equalTo(self.phoneScreenMaskView);
         make.size.mas_equalTo(self.phoneScreenMaskView);
     }];
    IFTTTAlphaAnimation *phoneScreenTodayAddedImageViewFadeInAnimation = [[IFTTTAlphaAnimation alloc] initWithView:self.phoneScreenTodayAddedImageView];
    [phoneScreenTodayAddedImageViewFadeInAnimation addKeyframeForTime:3.0 alpha:0.0f];
    [phoneScreenTodayAddedImageViewFadeInAnimation addKeyframeForTime:3.1 alpha:1.0f];
    [self.animator addAnimation:phoneScreenTodayAddedImageViewFadeInAnimation];
    
    self.phoneScreenTodayUnAddedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.phoneScreenTodayUnAddedLabel];
    self.phoneScreenTodayUnAddedLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.phoneScreenTodayUnAddedLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneScreenTodayUnAddedLabel.minimumScaleFactor = 0.02;
    self.phoneScreenTodayUnAddedLabel.textColor = UIColorFromRGB(0x272727);
    self.phoneScreenTodayUnAddedLabel.text = @"AFTER SETTING GITHUB ID, NAVIGATE TO TODAY VIEW AND PRESS 'EDIT'";
    self.phoneScreenTodayUnAddedLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneScreenTodayUnAddedLabel.numberOfLines = 0;
    [self.phoneScreenTodayUnAddedLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.1);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.4);
     }];
    [self keepView:self.phoneScreenTodayUnAddedLabel onPages:@[@(2)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    
    self.phoneScreenTodayAddingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phoneScreenTodayAdding"]];
    [self.phoneScreenMaskView addSubview:self.phoneScreenTodayAddingImageView];
    [self.phoneScreenTodayAddingImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.phoneScreenMaskView);
         make.size.mas_equalTo(self.phoneScreenMaskView);
     }];
    NSLayoutConstraint *phoneScreenTodayAddingImageViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.phoneScreenTodayAddingImageView
                                                                                                     attribute:NSLayoutAttributeCenterY
                                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                                        toItem:self.phoneScreenMaskView
                                                                                                     attribute:NSLayoutAttributeTop
                                                                                                    multiplier:1.0f constant:0.f];
    [self.phoneScreenMaskView addConstraint:phoneScreenTodayAddingImageViewTopConstraint];
    IFTTTConstraintMultiplierAnimation *phoneScreenTodayAddingImageViewTopConstraintMultiplierAnimation = [IFTTTConstraintMultiplierAnimation animationWithSuperview:self.phoneScreenMaskView
                                                                                                                      constraint:phoneScreenTodayAddingImageViewTopConstraint
                                                                                                                       attribute:IFTTTLayoutAttributeHeight
                                                                                                                   referenceView:self.phoneScreenMaskView];
    [phoneScreenTodayAddingImageViewTopConstraintMultiplierAnimation addKeyframeForTime:2 multiplier:2.f withEasingFunction:IFTTTEasingFunctionEaseOutCubic];
    [phoneScreenTodayAddingImageViewTopConstraintMultiplierAnimation addKeyframeForTime:3 multiplier:0.5f];
    [phoneScreenTodayAddingImageViewTopConstraintMultiplierAnimation addKeyframeForTime:4 multiplier:2.f];
    [self.animator addAnimation:phoneScreenTodayAddingImageViewTopConstraintMultiplierAnimation];
    
    [self.contentView addSubview:self.phoneScreenTodayUnAddedLabel];
    self.phoneScreenTodayUnAddedLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.phoneScreenTodayUnAddedLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneScreenTodayUnAddedLabel.minimumScaleFactor = 0.02;
    self.phoneScreenTodayUnAddedLabel.textColor = UIColorFromRGB(0x272727);
    self.phoneScreenTodayUnAddedLabel.text = @"AFTER SETTING GITHUB ID, NAVIGATE TO TODAY VIEW AND PRESS 'EDIT'";
    self.phoneScreenTodayUnAddedLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneScreenTodayUnAddedLabel.numberOfLines = 0;
    [self.phoneScreenTodayUnAddedLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.1);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.4);
     }];
    [self keepView:self.phoneScreenTodayUnAddedLabel onPages:@[@(2)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.phoneScreenTodayAddingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.phoneScreenTodayAddingLabel];
    self.phoneScreenTodayAddingLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.phoneScreenTodayAddingLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneScreenTodayAddingLabel.minimumScaleFactor = 0.02;
    self.phoneScreenTodayAddingLabel.textColor = UIColorFromRGB(0x272727);
    self.phoneScreenTodayAddingLabel.text = @"ADD 'GITHUB CONTRIBUTIONS' TO WIDGET LIST BY TAPPING ADD SYMBOL";
    self.phoneScreenTodayAddingLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneScreenTodayAddingLabel.numberOfLines = 0;
    [self.phoneScreenTodayAddingLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.1);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.4);
     }];
    [self keepView:self.phoneScreenTodayAddingLabel onPages:@[@(3)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    
    self.phoneScreenTodayAddedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.phoneScreenTodayAddedLabel];
    self.phoneScreenTodayAddedLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.phoneScreenTodayAddedLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneScreenTodayAddedLabel.minimumScaleFactor = 0.02;
    self.phoneScreenTodayAddedLabel.textColor = UIColorFromRGB(0x272727);
    self.phoneScreenTodayAddedLabel.text = @"AND YOU'RE ALL SET. YOU CAN VIEW 2D/3D GRAPH FROM TODAY VIEW";
    self.phoneScreenTodayAddedLabel.textAlignment = NSTextAlignmentCenter;
    self.phoneScreenTodayAddedLabel.numberOfLines = 0;
    [self.phoneScreenTodayAddedLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.1);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.4);
     }];
    [self keepView:self.phoneScreenTodayAddedLabel onPages:@[@(4)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    
    self.notificationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_notification"]];
    [self.phoneScreenMaskView addSubview:self.notificationImageView];
    [self.notificationImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.phoneScreenMaskView);
         make.width.mas_equalTo(self.phoneScreenMaskView);
         make.height.mas_equalTo(self.phoneScreenMaskView.mas_width).multipliedBy(0.3144);
     }];
    NSLayoutConstraint *notificationImageViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.notificationImageView
                                                                                                    attribute:NSLayoutAttributeCenterY
                                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                                       toItem:self.phoneScreenMaskView
                                                                                                    attribute:NSLayoutAttributeTop
                                                                                                   multiplier:1.0f constant:0.f];
    [self.phoneScreenMaskView addConstraint:notificationImageViewTopConstraint];
    IFTTTConstraintMultiplierAnimation *notificationImageViewTopConstraintMultiplierAnimation = [IFTTTConstraintMultiplierAnimation animationWithSuperview:self.phoneScreenMaskView
                                                                                                                                                          constraint:notificationImageViewTopConstraint
                                                                                                                                                           attribute:IFTTTLayoutAttributeHeight
                                                                                                                                                       referenceView:self.phoneScreenMaskView];
    [notificationImageViewTopConstraintMultiplierAnimation addKeyframeForTime:4 multiplier:-0.2f withEasingFunction:IFTTTEasingFunctionEaseOutCubic];
    [notificationImageViewTopConstraintMultiplierAnimation addKeyframeForTime:5 multiplier:0.09f];
    [notificationImageViewTopConstraintMultiplierAnimation addKeyframeForTime:6 multiplier:-0.2f];
    [self.animator addAnimation:notificationImageViewTopConstraintMultiplierAnimation];
    
    
    self.notificationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.notificationLabel];
    self.notificationLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.notificationLabel.adjustsFontSizeToFitWidth = YES;
    self.notificationLabel.minimumScaleFactor = 0.02;
    self.notificationLabel.textColor = UIColorFromRGB(0x272727);
    self.notificationLabel.text = @"NOTIFICATION CAN BE TRIGGERED ONCE BACKGROUND FETCH IS DONE (MAX 4 TIMES A DAY)";
    self.notificationLabel.textAlignment = NSTextAlignmentCenter;
    self.notificationLabel.numberOfLines = 0;
    [self.notificationLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.1);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.45);
     }];
    [self keepView:self.notificationLabel onPages:@[@(5)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    
    self.watchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"intro_watch"]];
    [self.contentView addSubview:self.watchImageView];
    [self.watchImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5);
         make.top.mas_equalTo(self.contentView);
     }];
    [self keepView:self.watchImageView onPages:@[@(6)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.watchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.watchLabel];
    self.watchLabel.font = [UIFont fontWithName:@"Avenir-Light" size:50];
    self.watchLabel.adjustsFontSizeToFitWidth = YES;
    self.watchLabel.minimumScaleFactor = 0.02;
    self.watchLabel.textColor = UIColorFromRGB(0x272727);
    self.watchLabel.text = @"DON'T FORGET TO CHECK CONTRIBUTIONS FOR APPLE WATCH WITH COMPLICATIONS";
    self.watchLabel.textAlignment = NSTextAlignmentCenter;
    self.watchLabel.numberOfLines = 0;
    [self.watchLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.35);
         make.top.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.5);
         make.bottom.mas_equalTo(self.contentView.mas_bottom).multipliedBy(0.9);
     }];
    [self keepView:self.watchLabel onPages:@[@(6)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    
    
    
    
    self.effectContainerView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.contentView addSubview:self.effectContainerView];
    [self.effectContainerView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.bottom.mas_equalTo(self.contentView.mas_bottom);
         make.centerX.mas_equalTo(self.contentView);
         make.width.mas_equalTo(self.view.mas_width);
         make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.1);
     }];
    [self keepView:self.effectContainerView onPages:@[@(0),@(1),@(2),@(3),@(4),@(5),@(6)] withAttribute:IFTTTHorizontalPositionAttributeCenterX];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [self.effectContainerView addSubview:self.pageControl];
    self.pageControl.numberOfPages = INTRO_TOTAL_PAGE_NUM;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.center.mas_equalTo(self.effectContainerView);
     }];
}


- (void)notificationSwitchValueChanged:(id)sender{
    if([sender isOn])
    {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                                                                            completionHandler:^(BOOL granted, NSError * _Nullable error)
         {}];
    }
    [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] setObject:[NSNumber numberWithBool:[sender isOn]] forKey:@"NotificationEnabled"];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.githubIdInputField)
    {
        NSString *trimmedName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] setObject:trimmedName forKey:@"GitHubContributionsName"];
        

        dispatch_queue_t gqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(gqueue, ^(void)
                       {
                           [[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] removeObjectForKey:@"GitHubContributionsArray"];
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
                                              
                                          });
                       });
        
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if (textField == self.githubIdInputField)
    {
        return ![string containsString:@" "];
    }
    
    return YES;
}

- (void)showShareSheet
{
    UIImage *img = [[JZDataVisualizationManager sharedManager] commitImageWithRect:CGRectMake(0, 0, 2000, 500) OS:JZDataVisualizationOSType_iOS_Notification];
    NSString *string = @"My GitHub contributions graph via #contributionsapp";
    NSMutableArray *activityItems = [NSMutableArray arrayWithObjects:string,img, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[];
    if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] )
    {
        activityViewController.popoverPresentationController.sourceView = self.view;
    }
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)showUserIDPage
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*1, 0.0f) animated:YES];
    [self.pageControl setCurrentPage:1];
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
