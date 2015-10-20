//
//  PCGroupView.h
//  Transporter
//
//  Created by Phillip Caudell on 03/05/2015.
//  Copyright (c) 2015 Phillip Caudell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+GroupView.h"

typedef NS_ENUM(NSInteger, PCGroupViewDirection) {
    PCGroupViewDirectionVertical = 1,
    PCGroupViewDirectionHorizontal = 2
};

@interface PCGroupView : UIView

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, assign) PCGroupViewDirection direction;
@property (nonatomic, assign) UIEdgeInsets viewInsets;
@property (nonatomic, assign) CGSize constraintSize;
@property (nonatomic, assign) PCGroupViewPosition viewAlignment;

+ (instancetype)groupWithViews:(NSArray *)views;

@end
