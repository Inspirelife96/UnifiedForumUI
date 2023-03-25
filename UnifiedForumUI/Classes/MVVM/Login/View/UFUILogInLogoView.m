//
//  UFUILogInLogoView.m
//  Bolts
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import "UFUILogInLogoView.h"

#import "UFUIBundle.h"

@interface UFUILogInLogoView ()

@property (nonatomic, strong) UIImage *logoImage;

@end

@implementation UFUILogInLogoView

- (instancetype)initWithLogoImage:(UIImage *)logoImage {
    if (self = [super init]) {
        _logoImage = logoImage;
    }
    
    return self;
}

// 这里是自己画出的一个图形，具体的算法就是数学问题了。
- (void)drawRect:(CGRect)rect {
    UIColor *primaryColor = [UIColor systemBackgroundColor];
    UIColor *secondaryColor = [UIColor labelColor];
    
    //获取图形上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    //设置点
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddLineToPoint(contextRef, viewWidth, 0);
    CGContextAddLineToPoint(contextRef, viewWidth, viewHeight);
    CGContextAddLineToPoint(contextRef, 0, viewHeight);
    
    //把点封闭起来
    CGContextClosePath(contextRef);
    
    //设置线宽
    CGContextSetLineWidth(contextRef, 0.0f);
    //设置线的颜色
    CGContextSetStrokeColorWithColor(contextRef, [UIColor clearColor].CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(contextRef, primaryColor.CGColor);
    
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    CGContextMoveToPoint(contextRef, 0, 0);
    CGContextAddLineToPoint(contextRef, viewWidth, 0);
    CGContextAddLineToPoint(contextRef, viewWidth, viewHeight/3.0f);
    CGContextAddLineToPoint(contextRef, 0, (viewHeight/3.0f)*2.0f/5.0f);
    
    //把点封闭起来
    CGContextClosePath(contextRef);
    
    //设置线宽
    CGContextSetLineWidth(contextRef, 0.0f);
    //设置线的颜色
    CGContextSetStrokeColorWithColor(contextRef, [UIColor clearColor].CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(contextRef, secondaryColor.CGColor);
    
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    CGContextMoveToPoint(contextRef, viewWidth*3.0f/4.0f, viewHeight/3.0f - viewHeight/3.0f * 3.0f / 5.0f / 4.0f);
    CGContextAddLineToPoint(contextRef, viewWidth, viewHeight/3.0f);
    CGContextAddLineToPoint(contextRef, viewWidth, viewHeight/3.0f/2.0f);
    
    //把点封闭起来
    CGContextClosePath(contextRef);
    
    //设置线宽
    CGContextSetLineWidth(contextRef, 0.0f);
    //设置线的颜色
    CGContextSetStrokeColorWithColor(contextRef, [UIColor clearColor].CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(contextRef, secondaryColor.CGColor);
    
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    CGFloat circleRadius = viewHeight/3.0f * 3.0f / 5.0f / 2.0f;
    
    CGFloat a = viewWidth;
    CGFloat b = viewHeight / 3.0 * 3.0 / 5.0;
    CGFloat c = sqrt(a*a + b*b);
    
    CGFloat x = (a / c) * circleRadius;
    CGFloat y = (b / c) * circleRadius;
    
    CGFloat degree = atan2(y, x);
    
    CGContextAddArc(contextRef, viewWidth/2.0, viewHeight/3.0 - circleRadius, circleRadius, -(M_PI - degree), degree, 0);
    
    CGContextSetLineWidth(contextRef, 10.0f);
    CGContextSetStrokeColorWithColor(contextRef, primaryColor.CGColor);
    
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    CGContextAddArc(contextRef, viewWidth/2.0, viewHeight/3.0 - circleRadius, circleRadius, -(M_PI - degree), degree, 1);
    
    CGContextSetLineWidth(contextRef, 10.0f);
    CGContextSetStrokeColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    
    // 先画一个圆形
    CGContextAddEllipseInRect(contextRef, CGRectMake(viewWidth/2.0 - circleRadius, viewHeight/3.0 - 2 * circleRadius, 2 * circleRadius, 2 * circleRadius));
    
    // 切割操作
    CGContextClip(contextRef);
    CGContextFillPath(contextRef);
    [self.logoImage drawInRect:CGRectMake(viewWidth/2.0 - circleRadius, viewHeight/3.0 - 2 * circleRadius, 2 * circleRadius, 2 * circleRadius)];
}

//- (UIImage *)logoImage {
//    if (!_logoImage) {
//        _logoImage = [UFUIBundle imageNamed:@"logo_default"];
//    }
//    
//    return _logoImage;
//}

@end
