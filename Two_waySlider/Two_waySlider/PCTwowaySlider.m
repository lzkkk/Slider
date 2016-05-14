//
//  PCTwowaySlider.m
//  Two_waySlider
//
//  Created by QF on 16/4/15.
//  Copyright © 2016年 Lip. All rights reserved.
//

#import "PCTwowaySlider.h"
#import "PCPaintPath.h"

#define PAN_LEFT_TAG        1001
#define PAN_RIGHT_TAG       1002

#define THUMBNAIL_WIDTH     53
#define THUMBNAIL_HEIGHT    48

@interface PCTwowaySlider() <UIGestureRecognizerDelegate>
{
    UIImageView *leftThumbnailImage;
    UIImageView *rightThumbnailImage;
    
    BOOL isOverlap;
    UIView *targetView;
    BOOL targetIsLeft;
}

@property (nonatomic, assign, readwrite) NSInteger currentValue;

@property (nonatomic, assign) BOOL setedLayoutSubviews;

@property (nonatomic, strong) CAShapeLayer *trackLayer;

@property (nonatomic, strong) CAShapeLayer *pathwayLayer;

@end


@implementation PCTwowaySlider

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
    
}

- (void)setup{
    
    leftThumbnailImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height- THUMBNAIL_HEIGHT)/2, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
    rightThumbnailImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - THUMBNAIL_WIDTH, (self.frame.size.height- THUMBNAIL_HEIGHT)/2, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];
    
    _backImage = [UIImage imageNamed:@"game_track_back"];
    _backImage = [_backImage stretchableImageWithLeftCapWidth:_backImage.size.width/2 topCapHeight:_backImage.size.height/2];

    leftThumbnailImage.image = [UIImage imageNamed:@"game_create_slider_money"];
    rightThumbnailImage.image = [UIImage imageNamed:@"game_create_slider_time"];
    
    UIPanGestureRecognizer *leftPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    leftPanRecognizer.delegate = self;
    [leftThumbnailImage addGestureRecognizer:leftPanRecognizer];
    leftThumbnailImage.tag = PAN_LEFT_TAG;
    leftThumbnailImage.userInteractionEnabled = YES;

    _stepNumber = 7;
    _currentLeftValue = 0;
    _currentRightValue = _stepNumber;
    _isTwoway = YES;
    
    _setedLayoutSubviews = NO;
    
    UIPanGestureRecognizer *rightPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    rightPanRecognizer.delegate = self;
    [rightThumbnailImage addGestureRecognizer:rightPanRecognizer];
    rightThumbnailImage.tag = PAN_RIGHT_TAG;
    rightThumbnailImage.userInteractionEnabled = YES;
    _trackColor = [UIColor grayColor];
    
    [self addSubview:leftThumbnailImage];
    [self addSubview:rightThumbnailImage];
//    [self setNeedsDisplay];
    [self drawTrackLayer];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    if (!_setedLayoutSubviews) {
        _setedLayoutSubviews = YES;
        leftThumbnailImage.frame = CGRectMake(0, (self.frame.size.height- THUMBNAIL_HEIGHT)/2, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
        rightThumbnailImage.frame = CGRectMake(self.frame.size.width - THUMBNAIL_WIDTH, (self.frame.size.height- THUMBNAIL_HEIGHT)/2, THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT);
        [self drawTrackLayer];
    }
    
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    CGContextRef conRef = UIGraphicsGetCurrentContext();
    CGRect backRect = CGRectMake(THUMBNAIL_WIDTH/2, (self.frame.size.height - 8)/2, (self.frame.size.width - THUMBNAIL_WIDTH), 8);
    
    [_backImage drawInRect:backRect];
    CGPoint fromPoint = leftThumbnailImage.center;
    CGPoint toPoint = rightThumbnailImage.center;
    CGContextMoveToPoint(conRef, fromPoint.x,fromPoint.y);
    CGContextAddLineToPoint(conRef, toPoint.x, toPoint.y);
    CGContextSetLineWidth(conRef, 6);
    CGContextSetLineCap(conRef, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(conRef, _trackColor.CGColor);
    CGContextStrokePath(conRef);
    
}

- (void)drawTrackLayer{
    
    if (_trackLayer) {
        [_trackLayer removeFromSuperlayer];
    }
    
    CGPoint fromPoint = leftThumbnailImage.center;
    
    CGPoint toPoint = rightThumbnailImage.center;
    
    PCPaintPath *path = [PCPaintPath LinePathWithWidth:4.0 StartPoint:fromPoint endPoint:toPoint];
    
    _trackLayer = [CAShapeLayer layer];
    
    _trackLayer.path = path.CGPath;
    
    _trackLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    _trackLayer.fillColor = [UIColor clearColor].CGColor;
    
    _trackLayer.lineCap = kCALineCapRound;
    
    _trackLayer.lineJoin = kCALineJoinRound;
    
    _trackLayer.strokeColor = [UIColor blackColor].CGColor;
    
    _trackLayer.lineWidth = path.lineWidth;
    
    [self.layer addSublayer:_trackLayer];
    
}

- (void)drawPahtwayLayer{
    
//    CAShapeLayer * slayer = [CAShapeLayer layer];
//    slayer.path = path.CGPath;
//    slayer.backgroundColor = [UIColor clearColor].CGColor;
//    slayer.fillColor = [UIColor clearColor].CGColor;
//    slayer.lineCap = kCALineCapRound;
//    slayer.lineJoin = kCALineJoinRound;
//    slayer.strokeColor = [UIColor blackColor].CGColor;
//    slayer.lineWidth = path.lineWidth;
//    [self.layer addSublayer:slayer];
    
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self];
    
//    NSLog(@"panGestureRecognizer.x ====> %lf",point.x);
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        if (CGRectEqualToRect(leftThumbnailImage.frame, rightThumbnailImage.frame)) {
            isOverlap = YES;
        } else {
            isOverlap = NO;
        }
        
        
        if (isOverlap) {
            
            if (point.x >= 0.0000001) {
                
                targetView = rightThumbnailImage;
                targetIsLeft = NO;
                
            }
            else {
                
                targetView = leftThumbnailImage;
                targetIsLeft = YES;
                
            }
            
        } else {
            
            targetView = pan.view;
            targetIsLeft = (pan.view.tag == PAN_LEFT_TAG) ? YES : NO;
            
        }
        
    }
    
    NSLog(@"targetView Tag ==>%zi",targetView.tag);
    
    __block CGPoint center = CGPointMake(targetView.center.x + point.x,
                                 targetView.center.y);

    center = [self validPanPoint:center
                          isLeft:targetIsLeft];
    
    targetView.center = center;
    
    [pan setTranslation:CGPointMake(0,0) inView:self];
    
    [self setNeedsDisplay];
//    [self drawTrackLayer];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        center = [self endPanPoint:center isLeft:targetIsLeft];
        
        targetView.center = center;
        
        [self setNeedsDisplay];
//        [self drawTrackLayer];
    }
    
}

- (CGPoint)validPanPoint:(CGPoint)point isLeft:(BOOL)isLeft{
    
    CGPoint validatePoint = point;
    if (isLeft) {
        
        if (point.x - THUMBNAIL_WIDTH/2 >= rightThumbnailImage.frame.origin.x) {
            validatePoint.x = rightThumbnailImage.frame.origin.x + THUMBNAIL_WIDTH / 2;
        }
    
        if (point.x <=  THUMBNAIL_WIDTH/2) {
            validatePoint.x = THUMBNAIL_WIDTH/2;
        }
        
    }
    else {
        if (point.x - THUMBNAIL_WIDTH /2 <= leftThumbnailImage.frame.origin.x) {
            validatePoint.x = leftThumbnailImage.frame.origin.x + THUMBNAIL_WIDTH / 2;
        }
        if (point.x >=  self.frame.size.width - THUMBNAIL_WIDTH/2) {
            validatePoint.x = self.frame.size.width - THUMBNAIL_WIDTH/2;
        }
    }
    return validatePoint;
    
}

//结束拖拽 按步长决定位置
- (CGPoint)endPanPoint:(CGPoint)point isLeft:(BOOL)isLeft{
    
    CGPoint endPoint = point;
//    NSLog(@"endPoint===>%lf",point.x);
    CGFloat step = (self.frame.size.width - THUMBNAIL_WIDTH) / _stepNumber;
    CGFloat centerX;
    if (0 == ([self pcTwowaySliderValue:point isLeft:isLeft] + 1))
    {
        centerX = THUMBNAIL_WIDTH/2;
    }
    else
    {
        centerX = ([self pcTwowaySliderValue:point isLeft:isLeft] + 1) * step + THUMBNAIL_WIDTH/2;
    }
    endPoint.x = centerX;
    return endPoint;
    
}

- (CGFloat)pcTwowaySliderValue:(CGPoint)point
                        isLeft:(BOOL)isLeft {
    
    CGFloat step = (self.frame.size.width - THUMBNAIL_WIDTH) / _stepNumber;
    float modelValue = ((point.x - THUMBNAIL_WIDTH/2) - step/2)/ step;
    BOOL isChange = NO;
    if (isLeft) {
        if (_currentLeftValue != (NSInteger)(floorf(modelValue) + 1)) {
            _currentLeftValue = (NSInteger)(floorf(modelValue) + 1);
            isChange = YES;
        }
    }
    else {
        if (_currentRightValue != (NSInteger)(floorf(modelValue) + 1)) {
            _currentRightValue = (NSInteger)(floorf(modelValue) + 1);
            isChange = YES;
        }
    }
    if (isChange) {
        if (_delegate && [_delegate respondsToSelector:@selector(pcTwowaySliderValue:isLeft:)]) {
            [_delegate pcTwowaySliderChangeValue:_currentLeftValue rightValue:_currentRightValue];
        }
    }
//    NSLog(@"modelValue ====> %lf",floorf(modelValue) + 1);
    return floorf(modelValue);
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    NSLog(@"%s",__PRETTY_FUNCTION__);
    return YES;
    
}

#pragma mark - Setter
- (void)setLeftImage:(UIImage *)leftImage{
    
    _leftImage = leftImage;
    leftThumbnailImage.image = leftImage;
    
}

- (void)setRightImage:(UIImage *)rightImage{
    
    _rightImage = rightImage;
    rightThumbnailImage.image = _rightImage;
    
}

- (void)setTrackColor:(UIColor *)trackColor{
    
    _trackColor = trackColor;
    [self setNeedsDisplay];
//    [self drawTrackLayer];
    
}

- (void)setStepValue:(NSInteger)stepValue{
    
    _stepNumber = stepValue;
    _currentRightValue = _stepNumber;
    [self setNeedsDisplay];
//    [self drawTrackLayer];
    
}

- (void)setIsTwoway:(BOOL)isTwoway{
    
    _isTwoway = isTwoway;
    leftThumbnailImage.hidden = !isTwoway;
    leftThumbnailImage.userInteractionEnabled = !isTwoway;
    
}

- (void)setBackImage:(UIImage *)backImage{
    if (!backImage) {
        return;
    }
    
    _backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width/2 topCapHeight:backImage.size.height/2];
    [self setNeedsDisplay];
    [self drawTrackLayer];

    
}

- (void)setCurrentLeftValue:(NSInteger)currentLeftValue{
    
    if (currentLeftValue < 0) {
        currentLeftValue = 0;
    }
    if (currentLeftValue > _stepNumber) {
        currentLeftValue = _stepNumber;
    }
    _currentLeftValue = currentLeftValue;
    CGPoint endPoint = leftThumbnailImage.center;
    CGFloat step = (self.frame.size.width - THUMBNAIL_WIDTH) / _stepNumber;
    CGFloat centerX;
    if (0 == currentLeftValue)
    {
        centerX = THUMBNAIL_WIDTH/2;
    }
    else
    {
        centerX = currentLeftValue * step + THUMBNAIL_WIDTH/2;
    }
    
    endPoint.x = centerX;
    CGRect frame = leftThumbnailImage.frame;
    frame.origin.x = centerX - THUMBNAIL_WIDTH/2;
    leftThumbnailImage.frame = frame;
    [self setNeedsDisplay];
//    [self drawTrackLayer];
    
}

- (void)setCurrentRightValue:(NSInteger)currentRightValue{
    
    if (currentRightValue < 0) {
        currentRightValue = 0;
    }
    if (currentRightValue > _stepNumber) {
        currentRightValue = _stepNumber;
    }
    
    _currentRightValue = currentRightValue;
    CGPoint endPoint = rightThumbnailImage.center;
    CGFloat step = (self.frame.size.width - THUMBNAIL_WIDTH) / _stepNumber;
    CGFloat centerX;
    if (0 == currentRightValue)
    {
        centerX = THUMBNAIL_WIDTH/2;
    }
    else
    {
        centerX = currentRightValue * step + THUMBNAIL_WIDTH/2;
    }
    
    endPoint.x = centerX;
    endPoint.x = centerX;
    CGRect frame = rightThumbnailImage.frame;
    frame.origin.x = centerX - THUMBNAIL_WIDTH/2;
    rightThumbnailImage.frame = frame;
//    [self setNeedsDisplay];
    [self drawTrackLayer];
    
}

@end
