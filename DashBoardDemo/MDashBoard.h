//
//  MDashBoard.h
//  DashBoardDemo
//
//  Created by lynx on 2020/7/21.
//  Copyright © 2020 lynx. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MDashBoardCircleType) {
    MDashBoardTypeHalf = 0, // semicircle.
    MDashBoardTypeAll       // circle.
};

@interface MDashBoard : UIView

@property(nonatomic, assign) MDashBoardCircleType circleType;
/// The default value is Yes.
@property (nonatomic, assign) BOOL showAnimation;
/// The default value is 1s.
@property (nonatomic, assign) CGFloat animationDuration;
/// The default value is 14.
@property (nonatomic, assign) CGFloat lineWidth;
/// Background Color.
@property (nonatomic, strong) UIColor *bgColor;
/// Stroke Color.
@property (nonatomic, strong) UIColor *strokeColor;
/// The default value is 100.
@property (nonatomic, assign) CGFloat maxValue;
/// Current Value.
@property (nonatomic, assign) CGFloat currentValue;

- (void)setupInterface;
- (void)setupInterfaceWithValue:(double)value;
- (void)setupInterfaceWithValue:(double)value color:(UIColor *)color;

@end
