//
//  ChartContentView.m
//  ChartViewDemoTest
//
//  Created by sfwan on 14-10-19.
//  Copyright (c) 2014年 sfwan. All rights reserved.
//

#import "ChartContentView.h"
#import "ChartTool.h"

#define kMaxValue           3000
#define kMinValue           500

@interface ChartContentView()

@end

@implementation ChartContentView
{
    NSMutableArray *_allPoints;
    CGPoint _selectedPoint;
    NSInteger _selectedIndex;
    NSArray *_range;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setColors:(NSArray *)colors
{
    _colors = colors;
    [self setNeedsDisplay];
}

-(id)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource range:(NSArray *)range colors:(NSArray *)colors
{
    self = [self initWithFrame:frame];
    if (self) {
        _dataSource = dataSource;
        self.backgroundColor = [UIColor clearColor];
        _allPoints = [NSMutableArray array];
        _range = range;
        _colors = colors;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_allPoints removeAllObjects];
    for (int i = 0; i < self.dataSource.count; i++) {
        UIColor *color = self.colors[i];
        [self drawPoint:context inRect:rect points:self.dataSource[i] color:color];
        [self drawLine:context inRect:rect points:self.dataSource[i] color:color];
    }
}

-(void)drawPoint:(CGContextRef)context inRect:(CGRect)rect points:(NSArray *)points color:(UIColor *)color
{
    CGFloat maxValue = [[_range lastObject] floatValue];
    CGFloat minValue = [[_range firstObject] floatValue];
    for (int i = 0; i < points.count; i++) {
        CGFloat value = [points[i] floatValue];
        CGPoint point = [ChartTool pointWithValue:value minValue:minValue maxValue:maxValue colunm:i rect:rect count:6];
        // 点击时数据展示内容
        NSString *text = [NSString stringWithFormat:@"%.0f%%", 100 * value/maxValue];
        
        if ([self isEqualPoint:point toPoint:_selectedPoint]) {
            [ChartTool drawPoint:context point:point color:color isSelected:YES text:text];
        } else {
            [ChartTool drawPoint:context point:point color:color];
        }
        [_allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
}

-(void)drawLine:(CGContextRef)context inRect:(CGRect)rect points:(NSArray *)points color:(UIColor *)color
{
    
    CGFloat maxValue = [[_range lastObject] floatValue];
    CGFloat minValue = [[_range firstObject] floatValue];
    CGPoint *_points = malloc(points.count * sizeof(CGPoint));
    for (int i = 0; i < points.count; i++) {
        CGFloat value = [points[i] floatValue];
        CGPoint point = [ChartTool pointWithValue:value minValue:minValue maxValue:maxValue colunm:i rect:rect count:6];
        _points[i] = point;
    }
    [ChartTool drawLines:context points:_points lineColor:color];
}

#pragma mark - touch action
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    for (NSValue *pointValue in _allPoints) {
        CGPoint existPoint = [pointValue CGPointValue];
        if ([self isEqualPoint:point toPoint:existPoint]) {
            _selectedPoint = existPoint;
            [self reDraw];
        }
    }
}

-(void)reDraw
{
    [self setNeedsDisplay];
}

-(BOOL)isEqualPoint:(CGPoint)p1 toPoint:(CGPoint)p2
{
    if (ABS(p1.x - p2.x) <= 5 && ABS(p1.y - p2.y) <= 5) {
        return YES;
    }
    
    return NO;
}

@end
