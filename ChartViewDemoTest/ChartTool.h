//
//  ChartTool.h
//  ChartViewDemoTest
//
//  Created by sfwan on 14-10-19.
//  Copyright (c) 2014年 sfwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOriginalX          50

@interface ChartTool : NSObject
// 原点坐标
+(CGPoint)axisOriginal:(CGRect)rect;
+(CGFloat)lineHeight:(NSInteger)count;
// 画虚线
+(void)setDrawLineDash:(CGContextRef)context;
// 轴文字数据
+(void)drawText:(NSString *)text point:(CGPoint)point textColor:(UIColor *)color textFont:(UIFont *)font;
// x 轴文字坐标
+(CGPoint)AxisXTextPoint:(CGPoint)referPoint;
// y 轴文字坐标
+(CGPoint)AxisYTextPoint:(CGPoint)referPoint;
// 原点平行于X坐标点
+(CGPoint)startHorizontalAxisPoint:(NSInteger)colum rect:(CGRect)rect;
// 原点垂直于X坐标点
+(CGPoint)startVerticalAxisPoint:(NSInteger)row rect:(CGRect)rect;

// 画点
+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color isSelected:(BOOL)selected text:(NSString *)text;
+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color;
+ (void)drawLines:(CGContextRef)context points:(CGPoint *)points lineColor:(UIColor *)lineColor;
// 画线
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor;

// 根据数据获取坐标值
+(CGPoint)pointWithValue:(CGFloat)value minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue colunm:(NSInteger)colunm rect:(CGRect)rect count:(NSInteger)count;
@end
