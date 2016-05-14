//
//  PCPaintPath.h
//  Two_waySlider
//
//  Created by QF on 16/4/16.
//  Copyright © 2016年 Lip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCPaintPath : UIBezierPath

+ (instancetype)LinePathWithWidth:(CGFloat)width
                       StartPoint:(CGPoint)staPoint
                         endPoint:(CGPoint)endPoint;

@end
