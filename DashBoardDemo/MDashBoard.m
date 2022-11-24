//
//  MDashBoard.m
//  DashBoardDemo
//
//  Created by lynx on 2020/7/21.
//  Copyright © 2020 lynx. All rights reserved.
//

#import "MDashBoard.h"

@interface MDashBoard ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat count;
@property (nonatomic, assign) CGFloat rate;

@end

@implementation MDashBoard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showAnimation = YES;
        self.animationDuration = 1.0f;
        self.maxValue = 100;
    }
    return self;
}

#pragma mark - Publick Method

- (void)setupInterface {
    self.centerPoint = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/self.rate);
    
    [self removeAllSubLayers];
    [self drawBackGrayCircle];
    [self drawCircle];
    [self loadNoteInfo];
}

- (void)setupInterfaceWithValue:(double)value {
    self.currentValue = value;
    [self setupInterface];
}

- (void)setupInterfaceWithValue:(double)value color:(UIColor *)color {
    self.currentValue = value;
    self.strokeColor = color;
    [self setupInterface];
}

- (void)resetInterface {
    self.showAnimation = YES;
    self.animationDuration = 1.0f;
    self.maxValue = 100;
    
    self.circleType = MDashBoardTypeHalf;
    self.lineWidth = 0;
    self.currentValue = 0;
    self.strokeColor = nil;
    self.bgColor = nil;
}

#pragma mark - Private Method

- (void)drawBackGrayCircle {
    CGFloat endAngle = self.circleType == MDashBoardTypeHalf ? 0 : M_PI;
    UIBezierPath *circlePath = [[UIBezierPath alloc] init];
    [circlePath addArcWithCenter:self.centerPoint radius:self.radius startAngle:-M_PI endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.lineWidth = self.lineWidth;
    circleLayer.fillColor = nil;
    circleLayer.strokeColor = self.bgColor.CGColor;
    circleLayer.path = circlePath.CGPath;
    circleLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:circleLayer];
}

- (void)drawCircle {
    UIBezierPath *circlePath = [[UIBezierPath alloc] init];
    CGFloat endAngle = self.currentValue * self.rate/self.maxValue * M_PI - M_PI;
    [circlePath addArcWithCenter:self.centerPoint radius:self.radius startAngle:-M_PI endAngle:endAngle clockwise:YES];

    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.lineWidth = self.lineWidth;
    circleLayer.fillColor = nil;
    circleLayer.strokeColor = self.strokeColor.CGColor;
    circleLayer.path = circlePath.CGPath;
    circleLayer.lineCap = kCALineCapRound;
    
    if (self.showAnimation) {
        CABasicAnimation *clockAnimation = [self animationWithDuration:self.animationDuration];
        [circleLayer addAnimation:clockAnimation forKey:nil];
    }
    
    [self.layer addSublayer:circleLayer];
}

- (void)loadNoteInfo {
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.radius * 2, 50)];
    self.contentLabel.font = [UIFont systemFontOfSize:36];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.center = self.centerPoint;
    [self addSubview:self.contentLabel];
    
    if (self.showAnimation) {
        self.count = 0;
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScore:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }else {
        self.contentLabel.text = [NSString stringWithFormat:@"%.1f",self.currentValue];
    }
}

- (void)updateScore:(CADisplayLink *)displayLink {
    self.count += 1.0;
    
    if (self.count >= self.currentValue) {
        [displayLink invalidate];
        self.contentLabel.text = [NSString stringWithFormat:@"%.1f",self.currentValue];
    }else {
        self.contentLabel.text = [NSString stringWithFormat:@"%.1f",self.count];
    }
}

- (CABasicAnimation *)animationWithDuration:(CGFloat)duraton {
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fillAnimation.duration = duraton;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = @(0.f);
    fillAnimation.toValue = @(1.f);
    return fillAnimation;
}

- (void)removeAllSubLayers{
    NSArray * subviews = [NSArray arrayWithArray:self.subviews];
    for (UIView * view in subviews) {
        [view removeFromSuperview];
    }
    
    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}

#pragma mark - Set & Get

- (CGFloat)radius {
    _radius = (self.frame.size.width/2.0 > self.frame.size.height) ? self.frame.size.height - self.lineWidth/2.0 : self.frame.size.width/2.0 - self.lineWidth/2.0;
    return _radius;
}

- (CGFloat)lineWidth {
    _lineWidth = _lineWidth ?: 14;
    return _lineWidth;
}

- (CGFloat)rate {
    CGFloat result = self.circleType == MDashBoardTypeHalf ? 1.0 : 2.0;
    return result;
}

- (UIColor *)strokeColor {
    if (!_strokeColor) {
        _strokeColor = [UIColor colorWithRed:122/255.0 green:193/255.0 blue:67/255.0 alpha:1];
    }
    return _strokeColor;
}

- (UIColor *)bgColor {
    if (!_bgColor) {
        _bgColor = [UIColor clearColor];
    }
    return _bgColor;
}

@end
