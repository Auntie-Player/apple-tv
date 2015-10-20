//
//  UIView+GroupView.h
//  Transporter
//
//  Created by Phillip Caudell on 24/06/2015.
//  Copyright (c) 2015 Phillip Caudell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GroupView)

typedef NS_ENUM(NSInteger, PCGroupViewPosition) {
    PCGroupViewPositionRight = 1,
    PCGroupViewPositionLeft = 2,
    PCGroupViewPositionTop = 3,
    PCGroupViewPositionBottom = 4,
    PCGroupViewPositionCenter = 5
};

- (void)positionInSuperviewX:(PCGroupViewPosition)xPosition y:(PCGroupViewPosition)yPosition offset:(UIEdgeInsets)offsetInsets;

@end
