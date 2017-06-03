//
//  ActionViewController.m
//  SafariSetAsUserAction
//
//  Created by Justin Fincher on 2017/6/3.
//  Copyright © 2017年 JustZht. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

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
	
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
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
						self.userNameLabel.text = [self getGitHubUserNameFrom:url];
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
	return YES;
}
- (NSString *)getGitHubUserNameFrom:(NSURL *)url
{
	return @"JustinFincher";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
