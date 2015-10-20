//
//  UIView+GroupView.m
//  Transporter
//
//  Created by Phillip Caudell on 24/06/2015.
//  Copyright (c) 2015 Phillip Caudell. All rights reserved.
//

#import "UIView+GroupView.h"

@implementation UIView (GroupView)

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
    
    if (yPosition == PCGroupViewPositionTop) {
        frame.origin.y = 0;
    }
    
    if (xPosition == PCGroupViewPositionRight) {
        frame.origin.x = superview.frame.size.width - frame.size.width;
    }
    
    if (yPosition == PCGroupViewPositionCenter) {
        frame.origin.y = superview.frame.size.height / 2 - frame.size.height / 2;
    }
    
    if (yPosition == PCGroupViewPositionBottom) {
        frame.origin.y = superview.frame.size.height - frame.size.height - offsetInsets.bottom;
    }
    
    frame.origin.x += offsetInsets.left;
    frame.origin.x -= offsetInsets.right;
    frame.origin.y += offsetInsets.top;
    
    self.frame = frame;
}

@end
