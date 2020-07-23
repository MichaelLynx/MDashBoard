//
//  MDashBoard.m
//  DashBoardDemo
//
//  Created by lynx on 2020/7/21.
//  Copyright © 2020 lynx. All rights reserved.
//

#import "MDashBoard.h"

@interface MDashBoard ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, strong) UILabel *scoreLb;
@property (nonatomic, assign) CGFloat currentScore;

@end

@implementation MDashBoard

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showAnimation = YES;
        self.animationDuration = 1.0f;
        self.maxScore = 100;
    }
    return self;
}

#pragma mark - Publick Method

- (void)strokePath {
    self.centerPoint = CGPointMake(self.frame.size.width/2.0, self.frame.size.height);
    
    [self removeAllSubLayers];
    [self drawBackGrayCircle];
    [self drawCircle];
    [self loadNoteInfo];
}

- (void)updateInterfaceWithValue:(double)value {
    self.centerPoint = CGPointMake(self.frame.size.width/2.0, self.frame.size.height);
    
    self.score = value;
    
    [self removeAllSubLayers];
    [self drawBackGrayCircle];
    [self drawCircle];
    [self loadNoteInfo];
}

- (void)updateInterfaceWithValue:(double)value color:(UIColor *)color {
    self.centerPoint = CGPointMake(self.frame.size.width/2.0, self.frame.size.height);
    
    self.score = value;
    if (color) {
        self.strokeColor = color;
    }
    
    [self removeAllSubLayers];
    [self drawBackGrayCircle];
    [self drawCircle];
    [self loadNoteInfo];
}

#pragma mark - Private Method

- (void)drawBackGrayCircle {
    UIBezierPath *circlePath = [[UIBezierPath alloc] init];
    [circlePath addArcWithCenter:self.centerPoint radius:self.radius startAngle:-M_PI endAngle:0 clockwise:YES];
    
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
    CGFloat endAngle = self.score/self.maxScore * M_PI - M_PI;
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
    self.scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.radius * 2, 50)];
    self.scoreLb.font = [UIFont systemFontOfSize:36];
    self.scoreLb.textColor = [UIColor blackColor];
    self.scoreLb.textAlignment = NSTextAlignmentCenter;
    self.scoreLb.center = self.centerPoint;
    [self addSubview:self.scoreLb];
    
    if (self.showAnimation) {
        self.currentScore = 0;
        
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScore:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }else {
        self.scoreLb.text = [NSString stringWithFormat:@"%.1f",self.score];
    }
}

- (void)updateScore:(CADisplayLink *)displayLink {
    self.currentScore += 1.0;
    
    if (self.currentScore >= self.score) {
        [displayLink invalidate];
        self.scoreLb.text = [NSString stringWithFormat:@"%.1f",self.score];
    }else {
        self.scoreLb.text = [NSString stringWithFormat:@"%.1f",self.currentScore];
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

- (UIColor *)strokeColor {
    if (!_strokeColor) {
        _strokeColor = [UIColor colorWithRed:122/255.0 green:193/255.0 blue:67/255.0 alpha:1];
    }
    return _strokeColor;
}

- (UIColor *)bgColor {
    if (!_bgColor) {
        _bgColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    }
    return _bgColor;
}

@end
