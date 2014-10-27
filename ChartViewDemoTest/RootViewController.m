//
//  RootViewController.m
//  ChartViewDemoTest
//
//  Created by sfwan on 14-10-19.
//  Copyright (c) 2014年 sfwan. All rights reserved.
//

#import "RootViewController.h"
#import "ChartView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *yAxis = @[@"500",@"1000", @"1500", @"2000", @"2500", @"3000"];
    NSArray *xAxis = @[@"1Aprl", @"2Aprl", @"3Aprl", @"4Aprl", @"5Aprl"];
    
    NSDictionary *dataSource = @{@"data":@[@[@500, @800, @1100, @2000, @2700], @[@300, @1100, @2200, @1200, @3000]], @"titles":@[@"展博一期", @"卢深300"]};
    
    ChartView *chartView = [[ChartView alloc] initWithFrame:CGRectMake(0, 100, 320, 180) dataSource:dataSource axisYTitles:yAxis axisXTitles:xAxis colors:self.colors];
    chartView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chartView];
    
    
    // 可以重设颜色
//    chartView.colors = @[[UIColor purpleColor], [UIColor orangeColor]];
}

// 设置线条颜色
-(NSArray *)colors{
    return @[[UIColor orangeColor], [UIColor purpleColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
