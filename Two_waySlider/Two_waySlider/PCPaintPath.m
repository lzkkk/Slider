//
//  PCPaintPath.m
//  Two_waySlider
//
//  Created by QF on 16/4/16.
//  Copyright © 2016年 Lip. All rights reserved.
//

#import "PCPaintPath.h"

@implementation PCPaintPath

+ (instancetype)LinePathWithWidth:(CGFloat)width
                       StartPoint:(CGPoint)staPoint
                         endPoint:(CGPoint)endPoint{
    PCPaintPath *path  = [[PCPaintPath alloc] init];
    path.lineWidth = width;
    path.lineCapStyle = kCGLineCapRound;
    [path moveToPoint:staPoint];
    [path addLineToPoint:endPoint];
    return path;
    
}

@end
