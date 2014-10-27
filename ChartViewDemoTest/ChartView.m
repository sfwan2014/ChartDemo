//
//  ChartView.m
//  ChartViewDemoTest
//
//  Created by sfwan on 14-10-19.
//  Copyright (c) 2014年 sfwan. All rights reserved.
//

#import "ChartView.h"
#import "ChartTool.h"
#import "ChartContentView.h"
#define rgb(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//#define kLineHeight         130
#define kDashLineWidth          0.3
#define kDashLineColor          rgb(167, 167, 167, 1)
#define kTextColor              [UIColor grayColor]
#define kDefaultTextFontSize     8
#define kDefaultDesTextColor    [UIColor darkTextColor]

#define kSeperateColor          [UIColor grayColor]
#define kSeperateLineWidth      0.1

@implementation ChartView
{
    NSArray *_aYTitles;
    NSArray *_aXTitles;
    
    ChartContentView *chartContentView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame dataSource:(NSDictionary *)dataSource axisYTitles:(NSArray *)aYTitles axisXTitles:(NSArray *)aXTitles colors:(NSArray *)colors
{
    self = [self initWithFrame:frame];
    if (self) {
        _aYTitles = aYTitles;
        _aXTitles = aXTitles;
        _dataSource = dataSource;
        _colors = colors;
        
        NSArray *array = dataSource[@"data"];
        // 添加折线视图
        chartContentView = [[ChartContentView alloc] initWithFrame:self.bounds dataSource:array range:@[[aYTitles firstObject], [aYTitles lastObject]] colors:_colors];
        
        [self addSubview:chartContentView];
        
    }
    return self;
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
    chartContentView.colors = colors;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *titles = _dataSource[@"titles"];
    CGFloat width = self.frame.size.width / titles.count;
    for (int i = 0; i < titles.count; i++) {
        CGPoint point= CGPointMake( i * width + 30, 20);
        NSString *title = titles[i];
        UIColor *color = self.colors[i];
        // 画描述
        [self drawDescriptionContext:context point:point text:title textColor:kDefaultDesTextColor fillColor:color];
    }
    
    [self drawAxisX:context rect:rect];
    
    [self drawAllAxisY:context rect:rect];
    [self drawAllAxisX:context rect:rect];
    
    [self drawXTexts:rect];
    [self drawYTexts:rect];
}

-(void)drawDescriptionContext:(CGContextRef)context point:(CGPoint)point text:(NSString *)text textColor:(UIColor *)textColor fillColor:(UIColor *)fillColor
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGRect frame = CGRectMake(point.x, point.y, 15, 15);
    CGContextAddRect(context, frame);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    point.x = point.x + 20;
    [ChartTool drawText:text point:point textColor:textColor textFont:[UIFont systemFontOfSize:14]];
    
    point.y += 30;
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, kSeperateColor.CGColor);
    CGContextSetLineWidth(context, kSeperateLineWidth);
    CGContextMoveToPoint(context, 0, point.y);
    CGContextAddLineToPoint(context, self.frame.size.width, point.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

// X轴
-(void)drawAxisX:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGPoint startPoint = [ChartTool axisOriginal:rect];
    CGPoint endPoint = CGPointMake(rect.size.width-20, startPoint.y);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}
// Y轴
-(void)drawAxisY:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGPoint startPoint = [ChartTool startHorizontalAxisPoint:0 rect:rect];
    CGPoint endPoint = CGPointMake(startPoint.x, startPoint.y-[ChartTool lineHeight:_aYTitles.count]);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}
// 垂直Y轴虚线
-(void)drawAllAxisX:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, kDashLineColor.CGColor);
    CGContextSetLineWidth(context, kDashLineWidth);
    
    [ChartTool setDrawLineDash:context];
    
    for (int i = 1; i <= _aYTitles.count; i++) {
        CGPoint startPoint = [ChartTool startVerticalAxisPoint:i rect:rect];
        CGPoint endPoint = CGPointMake(rect.size.width-20, startPoint.y);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
    
    CGContextRestoreGState(context);
}
// 垂直X轴虚线
-(void)drawAllAxisY:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, kDashLineColor.CGColor);
    CGContextSetLineWidth(context, kDashLineWidth);
    [ChartTool setDrawLineDash:context];
    
    for (int i = 1; i < _aXTitles.count; i++) {
        CGPoint startPoint = [ChartTool startHorizontalAxisPoint:i rect:rect];
        CGPoint endPoint = CGPointMake(startPoint.x, startPoint.y-[ChartTool lineHeight:_aYTitles.count]-10);
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}



#pragma mark - draw text
// 画X轴上的点的坐标数据
-(void)drawXTexts:(CGRect)rect
{
    for (int i = 0; i < _aXTitles.count; i++) {
        CGPoint startPoint = [ChartTool startHorizontalAxisPoint:i rect:rect];
        [self drawXText:_aXTitles[i] referPoint:startPoint];
    }
}

-(void)drawXText:(NSString *)text referPoint:(CGPoint)referPoint
{
    CGPoint point = [ChartTool AxisXTextPoint:referPoint];
    [ChartTool drawText:text point:point textColor:kTextColor textFont:[UIFont systemFontOfSize:kDefaultTextFontSize]];
}
// 画y轴上的点的坐标数据
-(void)drawYTexts:(CGRect)rect
{
    for (int i = 1; i <= _aYTitles.count; i++) {
        CGPoint startPoint = [ChartTool startVerticalAxisPoint:i rect:rect];
        [self drawYText:_aYTitles[i-1] referPoint:startPoint];
    }
}

-(void)drawYText:(NSString *)text referPoint:(CGPoint)referPoint
{
    CGPoint point = [ChartTool AxisYTextPoint:referPoint];
    [ChartTool drawText:text point:point textColor:kTextColor textFont:[UIFont systemFontOfSize:kDefaultTextFontSize]];
}

@end
