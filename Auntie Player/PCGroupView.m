//
//  PCGroupView.m
//  Transporter
//
//  Created by Phillip Caudell on 03/05/2015.
//  Copyright (c) 2015 Phillip Caudell. All rights reserved.
//

#import "PCGroupView.h"

@interface PCGroupView ()

@end

@implementation PCGroupView

+ (instancetype)groupWithViews:(NSArray *)views
{
    PCGroupView *view = [PCGroupView new];
    view.views = views;
    
    return view;
}

- (void)setViews:(NSArray *)views
{
    [self willChangeValueForKey:@"views"];
    
    _views = views;
    
    [self.views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [self addSubview:view];
    }];
    
    [self didChangeValueForKey:@"views"];
}

- (void)sizeToFit
{
    [self performLayout];
}

- (void)performLayout
{
    switch (self.direction) {
        case PCGroupViewDirectionVertical:
            [self layoutVertically];
            break;
        case PCGroupViewDirectionHorizontal:
            [self layoutHorizontally];
            break;
        default:
            break;
    }
}

- (void)layoutHorizontally
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat greatestHeight = 0;
    
    // Size
    for (UIView *view in self.views) {
        
        CGSize size = [view sizeThatFits:self.constraintSize];
        
        view.frame = CGRectMake(x, y + self.viewInsets.top, size.width, size.height);
        
        x += size.width + self.viewInsets.right + self.viewInsets.left;
        
        if (size.height > greatestHeight) {
            greatestHeight = size.height;
        }
    }
    
    // Alignment
    for (UIView *view in self.views) {
        
        CGRect frame = view.frame;
        
        if (self.viewAlignment == PCGroupViewPositionCenter) {
            
            frame.origin.x = (greatestHeight / 2) - view.frame.size.width / 2;
        }
        
        view.frame = frame;
    }
    
    CGRect frame = self.frame;
    frame.size.width = x;
    frame.size.height = greatestHeight;
    
    self.frame = frame;
}

- (void)layoutVertically
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat greatestWidth = 0;
    
    // Size
    for (UIView *view in self.views) {
        
        CGSize size = [view sizeThatFits:self.constraintSize];
        
        view.frame = CGRectMake(x, y + self.viewInsets.top, size.width, size.height);
        
        y += size.height + self.viewInsets.bottom + self.viewInsets.top;
        
        if (size.width > greatestWidth) {
            greatestWidth = size.width;
        }
    }
    
    // Alignment
    for (UIView *view in self.views) {
        
        CGRect frame = view.frame;
        
        if (self.viewAlignment == PCGroupViewPositionCenter) {

            frame.origin.x = (greatestWidth / 2) - view.frame.size.width / 2;
        }
        
        view.frame = frame;
    }
    
    CGRect frame = self.frame;
    frame.size.width = greatestWidth;
    frame.size.height = y;
    
    self.frame = frame;
}

- (void)positionInSuperviewX:(PCGroupViewPosition)xPosition y:(PCGroupViewPosition)yPosition offset:(UIEdgeInsets)offsetInsets
{
    CGRect frame = self.frame;
    UIView *superview = self.superview;
    
    if (xPosition == PCGroupViewPositionCenter) {
        frame.origin.x = superview.frame.size.width / 2 - frame.size.width / 2;
    }
    
    if (xPosition == PCGroupViewPositionLeft) {
        frame.origin.x = 0;
    }
    
    if (xPosition == PCGroupViewPositionRight) {
        frame.origin.x = superview.frame.size.width - frame.size.width;
    }
    
    if (yPosition == PCGroupViewPositionCenter) {
        frame.origin.y = superview.frame.size.height / 2 - frame.size.height / 2;
    }
    
    frame.origin.x += offsetInsets.left;
    frame.origin.x -= offsetInsets.right;
    frame.origin.y += offsetInsets.top;
    
    self.frame = frame;
}

@end
