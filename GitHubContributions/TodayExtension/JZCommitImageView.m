//
//  JZCommitImageView.m
//  GitHubContributions
//
//  Created by Fincher Justin on 16/9/11.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#import "JZCommitImageView.h"
#import "JZCommitManager.h"
#import "JZCommitDataModel.h"
#import "JZDataVisualizationManager.h"
@implementation JZCommitImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder]))
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layerWillDraw:(CALayer *)layer {
    [super layerWillDraw:layer];
    layer.contentsFormat = kCAContentsFormatRGBA8Uint;
}

- (void)refreshData
{
    self.image = [[JZDataVisualizationManager sharedManager] commitImageWithRect:self.frame OS:JZDataVisualizationOSType_iOS_Widget];
}

@end
