//
//  ExtensionDelegate.h
//  ContributionsOnWatch Extension
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@interface ExtensionDelegate : NSObject <WKExtensionDelegate>
- (void)updateComplications;
@end
