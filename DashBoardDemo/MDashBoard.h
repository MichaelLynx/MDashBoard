//
//  MDashBoard.h
//  DashBoardDemo
//
//  Created by lynx on 2020/7/21.
//  Copyright © 2020 lynx. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MDashBoard : UIView

///The default value is Yes.
@property (nonatomic, assign) BOOL showAnimation;
///The default value is 1s.
@property (nonatomic, assign) CGFloat animationDuration;
///The default value is 14.
@property (nonatomic, assign) CGFloat lineWidth;
///The default value is 100.
@property (nonatomic, assign) CGFloat maxScore;
@property (nonatomic, assign) CGFloat score;

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *strokeColor;

- (void)strokePath;

- (void)updateInterfaceWithValue:(double)value;
- (void)updateInterfaceWithValue:(double)value color:(UIColor *)color;

@end
