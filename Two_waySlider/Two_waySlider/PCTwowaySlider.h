//
//  PCTwowaySlider.h
//  Two_waySlider
//
//  Created by QF on 16/4/15.
//  Copyright © 2016年 Lip. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PCTwowaySliderDelegate;

@interface PCTwowaySlider : UIView

@property (nonatomic, assign) NSInteger stepNumber;//default  step Number is 5;

@property (nonatomic, strong) UIImage *leftImage;//左滑标图片

@property (nonatomic, strong) UIImage *rightImage;//右滑标图片

@property (nonatomic, strong) UIColor *trackColor;//轨迹颜色

@property (nonatomic, strong) UIImage *backImage;//背景颜色

@property (nonatomic, assign) NSInteger currentLeftValue;//左边值

@property (nonatomic, assign) NSInteger currentRightValue;//右边值

@property (nonatomic, assign) id <PCTwowaySliderDelegate> delegate;

@property (nonatomic, assign) BOOL isTwoway;//default value is YES

@end


@protocol PCTwowaySliderDelegate <NSObject>

- (void)pcTwowaySliderChangeValue:(NSInteger)leftvalue rightValue:(NSInteger)rightValue;

@end