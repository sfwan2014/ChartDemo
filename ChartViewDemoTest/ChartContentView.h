//
//  ChartContentView.h
//  ChartViewDemoTest
//
//  Created by sfwan on 14-10-19.
//  Copyright (c) 2014年 sfwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartContentView : UIControl
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *colors;
-(id)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource range:(NSArray *)range colors:(NSArray *)colors;
@end
