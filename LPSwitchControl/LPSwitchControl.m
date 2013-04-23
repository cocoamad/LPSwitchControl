//
//  LPSwitchControl.m
//  LPSwitchControl
//
//  Created by Penny on 14/03/13.
//  Copyright (c) 2013 Penny. All rights reserved.
//

#import "LPSwitchControl.h"
@interface LPSwitchControl()
@property (nonatomic, assign) CGFloat offx;
@property (nonatomic, assign) BOOL isDown;
@end

@implementation LPSwitchControl
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.on = YES;
    }
    return self;
}

#pragma mark Setter
- (void)setOn:(BOOL)on
{
    if (_on != on) {
        _on = on;
        [self setNeedsDisplay];
    }
}

- (void)setIsDown:(BOOL)isDown
{
    if (_isDown != isDown) {
        _isDown = isDown;
        [self setNeedsDisplay];
    }
}

#pragma mark Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView: self];
    NSLog(@"touchesBegan %@", NSStringFromCGPoint(point));
    if (!CGRectContainsPoint([self _indicationRect], point)) {
        self.on = !self.on;
    }
    self.isDown = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView: self];
    NSLog(@"touchesEnded %@", NSStringFromCGPoint(point));
    self.isDown = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView: self];
    NSLog(@"touchesMoved %@", NSStringFromCGPoint(point));
    if (CGRectContainsPoint([self _indicationRect], point)) {
        
    }
}

#pragma mark -
- (CGRect)_indicationRect
{
    if (self.on) {
        return CGRectMake(ceil(self.bounds.size.width / 3 * 2), self.bounds.origin.y, ceil(self.bounds.size.width / 3), self.bounds.size.height);
    } else {
        return CGRectMake(self.bounds.origin.x, self.bounds.origin.y, ceil(self.bounds.size.width / 3), self.bounds.size.height);
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // draw indicate
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
    CGContextAddRect(ctx, [self _indicationRect]);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
    
    // draw down state
    CGContextSaveGState(ctx);
    if (_isDown) {
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextSetAlpha(ctx, .2f);
        CGContextAddRect(ctx, [self _indicationRect]);
        CGContextFillPath(ctx);
    }
    CGContextRestoreGState(ctx);
    
    // draw background
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, 1);
    CGContextAddRect(ctx, self.bounds);
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}
@end
