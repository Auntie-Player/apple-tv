//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Phillip Caudell & Matthew Cheetham
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//

#import "EpisodeCollectionViewCell.h"
#import "UIColor+Auntie.h"

@implementation EpisodeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[AsyncImageView alloc] init];
        self.imageView.adjustsImageWhenAncestorFocused = YES;
        self.imageView.clipsToBounds = false;
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [UILabel new];
        self.textLabel.text = @"Episode Name";
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:28];
        [self.contentView addSubview:self.textLabel];
        
        self.detailLabel = [UILabel new];
        self.detailLabel.text = @"Episode Subtitle";
        self.detailLabel.textColor = [UIColor lightGrayColor];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.font = [UIFont systemFontOfSize:24];
        self.detailLabel.alpha = 0;
        [self.contentView addSubview:self.detailLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 60;
    CGFloat width = self.contentView.bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    
    self.imageView.frame = CGRectMake(padding, padding, width - (padding * 2), height - (padding * 2));
    
    CGFloat imageOffsetY = self.imageView.focusedFrameGuide.layoutFrame.size.height + padding;
    
    self.textLabel.frame = CGRectMake(0, imageOffsetY, width, 30);
    self.detailLabel.frame = CGRectMake(0, imageOffsetY + 30, width, 30);
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    [coordinator addCoordinatedAnimations:^{
        
        if (self.focused) {
            self.textLabel.textColor = [UIColor auntiePinkColor];
            self.detailLabel.alpha = 1.0;
        } else {
            self.textLabel.textColor = [UIColor whiteColor];
            self.detailLabel.alpha = 0.0;
        }
        
    } completion:nil];
}

@end
