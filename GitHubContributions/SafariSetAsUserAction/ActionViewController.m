//
//  ActionViewController.m
//  SafariSetAsUserAction
//
//  Created by Justin Fincher on 2017/6/3.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define JZSuiteName @"group.com.JustZht.GitHubContributions"

@interface ActionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *successView;
@property (weak, nonatomic) IBOutlet UIView *failView;
@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.successView.hidden = YES;
	self.failView.hidden = YES;

    BOOL urlFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL])
			{
				[itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:[NSDictionary dictionary] completionHandler:^(id item, NSError *error)
				{
					NSURL *url = (NSURL *)item;
					if ([self isValidGitHubURLFrom:url])
					{
						self.successView.hidden = NO;
						NSString *trimmedName = [[self getGitHubUserNameFrom:url] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
						self.userNameLabel.text = trimmedName;
						[[[NSUserDefaults alloc] initWithSuiteName:JZSuiteName] setObject:trimmedName forKey:@"GitHubContributionsName"];
						
						
					}else
					{
						self.failView.hidden = NO;
					}
				}];
				urlFound = YES;
                break;
            }
        }
        
        if (urlFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (BOOL)isValidGitHubURLFrom:(NSURL *)url
{
    
    NSArray *arr = [[url absoluteString] componentsSeparatedByString:@"github.com/"];
    NSString *lastString = [arr objectAtIndex:1];
    if (lastString != nil && ![lastString isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}
- (NSString *)getGitHubUserNameFrom:(NSURL *)url
{
    NSArray *arr = [[url absoluteString] componentsSeparatedByString:@"github.com/"];
    NSString *lastString = [arr objectAtIndex:1];
    if (lastString != nil && ![lastString isEqualToString:@""])
    {
        return [[lastString componentsSeparatedByString:@"/"] firstObject];
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openApp:(id)sender
{
	UIResponder* responder = self;
	while ((responder = [responder nextResponder]) != nil)
	{
//		NSLog(@"responder = %@", responder);
		if([responder respondsToSelector:@selector(openURL:)] == YES)
		{
			[responder performSelector:@selector(openURL:) withObject: [NSURL URLWithString:@"com.JustZht.GitHubContributions://" ]];
		}
	}
	[self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

- (IBAction)done:(id)sender
{
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
