//
//  ViewController.m
//  Two_waySlider
//
//  Created by QF on 16/4/15.
//  Copyright © 2016年 Lip. All rights reserved.
//

#import "ViewController.h"
#import "PCTwowaySlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PCTwowaySlider *slider = [[PCTwowaySlider alloc] initWithFrame:CGRectMake(0, 100, 320, 568)];
//    slider.isTwoway = NO;
//    slider.currentRightValue = 0;
    slider.backgroundColor = [UIColor redColor];
    [self.view addSubview:slider];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
