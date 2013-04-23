//
//  LPSwitch.m
//  LPSwitchControl
//
//  Created by Penny on 15/03/13.
//  Copyright (c) 2013 Penny. All rights reserved.
//

#import "LPSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface LPSwitch ()
@property (nonatomic, retain) CALayer *backgroundLayer;
@property (nonatomic, retain) CALayer *indicationLayer;
@property (nonatomic, retain) CALayer *pointLayer;
@property (nonatomic, assign) BOOL isMouseDown;
@property (nonatomic, assign) BOOL isMove;
@property (nonatomic, assign) CGFloat offx;
@property (nonatomic, assign) CGPoint lastDownPoint;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@end

@implementation LPSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.layer.bounds.size.height / 2;
        self.on = NO;
        
        self.backgroundLayer = [CALayer layer];
        self.backgroundLayer.frame = self.layer.bounds;
        self.backgroundLayer.cornerRadius = self.layer.bounds.size.height / 2;
        self.backgroundLayer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundLayer.borderWidth = 1;
        self.backgroundLayer.backgroundColor = [UIColor grayColor].CGColor;
        self.backgroundLayer.masksToBounds = YES;
        [self.layer addSublayer: self.backgroundLayer];
        
        self.indicationLayer = [CALayer layer];
        self.indicationLayer.backgroundColor = [UIColor orangeColor].CGColor;
        self.indicationLayer.cornerRadius = self.layer.bounds.size.height / 2;
        self.indicationLayer.frame = [self _indicationRect];
        self.indicationLayer.masksToBounds = YES;
        [self.layer addSublayer: self.indicationLayer];
        
        self.pointLayer = [CALayer layer];
        self.pointLayer.frame = CGRectMake(self.indicationLayer.bounds.size.width - self.indicationLayer.bounds.size.height,
                                      self.indicationLayer.bounds.origin.y, self.indicationLayer.bounds.size.height, self.indicationLayer.bounds.size.height);
        self.pointLayer.cornerRadius = self.layer.bounds.size.height / 2;
        self.pointLayer.backgroundColor = [UIColor blueColor].CGColor;
        [self.indicationLayer addSublayer: self.pointLayer];
        
        
        
    }
    return self;
}

#pragma mark -
- (void)setTintColor:(UIColor *)tintColor
{
    if (![_tintColor isEqual: tintColor]) {
        [_tintColor release];
        _tintColor = [tintColor retain];
        self.backgroundLayer.backgroundColor = _tintColor.CGColor;
    }
}

- (void)setOnTintColor:(UIColor *)onTintColor
{
    if (![_onTintColor isEqual: onTintColor]) {
        [_onTintColor release];
        _onTintColor = [onTintColor retain];
        self.indicationLayer.backgroundColor = _onTintColor.CGColor;
    }
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    if (![_thumbTintColor isEqual: thumbTintColor]) {
        [_thumbTintColor release];
        _thumbTintColor = [thumbTintColor retain];
        self.pointLayer.backgroundColor = _thumbTintColor.CGColor;
    }
}

#pragma mark -
- (void)setOnImage:(UIImage *)onImage
{
    self.indicationLayer.contents = (id)onImage.CGImage;
}

- (void)setOffImage:(UIImage *)offImage
{
    self.backgroundLayer.contents = (id)offImage.CGImage;
}

- (void)setPointImage:(UIImage *)pointImage
{
    self.pointLayer.contents = (id)pointImage.CGImage;
}

#pragma mark - 
- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _selector = action;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{  
    if (animated) {
        [CATransaction begin];
        [CATransaction setAnimationDuration: .2];
        if (_on != on) {
            [CATransaction setCompletionBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_target && [_target respondsToSelector: _selector]) {
                        [_target performSelector: _selector withObject: self];
                    }
                });
            }];
        }
        _on = on;
        [CATransaction setAnimationTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]];
        self.indicationLayer.frame = [self _indicationRect];
        [CATransaction commit];
    } else {
        if (on != _on) {
            if (_target && [_target respondsToSelector: _selector]) {
                [_target performSelector: _selector withObject: self];
            }
        }
        _on = on;
        [CATransaction begin];
        [CATransaction setDisableActions: YES];
        self.indicationLayer.frame = [self _indicationRect];
        [CATransaction commit];
    }
}

#pragma mark Private Method
- (CGRect)_indicationRect
{
    if (!self.on) {
        return CGRectMake(-ceil(self.bounds.size.width - self.layer.bounds.size.height), self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    } else {
        return CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    }
}

- (CGRect)_pointRect
{
    if (self.on) {
        return CGRectMake(self.bounds.size.width - self.layer.bounds.size.height, self.bounds.origin.y, self.bounds.size.height, self.bounds.size.height);
    } else {
        return CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.height, self.bounds.size.height);
    }
}

- (void)setIsMouseDown:(BOOL)isMouseDown
{
    if (_isMouseDown != isMouseDown) {
        _isMouseDown = isMouseDown;
        if (_isMouseDown) {
            CALayer *foreBGLayer = [CALayer layer];
            foreBGLayer.backgroundColor = [UIColor blackColor].CGColor;
            foreBGLayer.opacity = .2f;
            foreBGLayer.frame = self.pointLayer.bounds;
            foreBGLayer.cornerRadius = self.pointLayer.cornerRadius;
            [foreBGLayer setValue: @"YES" forKey: @"foreBgLayer"];
            [self.pointLayer addSublayer: foreBGLayer];
        } else {
            NSArray *subLayers = self.pointLayer.sublayers;
            for (CALayer *layer in subLayers) {
                if ([[layer valueForKey: @"foreBgLayer"] isEqualToString: @"YES"]) {
                    [layer removeFromSuperlayer];
                    break;
                }
            }
        }
    }
}

- (void)setOffx:(CGFloat)offx
{
    CGRect frame = self.indicationLayer.frame;
    frame.origin.x += offx;
    frame.origin.x = frame.origin.x > 0 ? 0 : frame.origin.x;
    frame.origin.x = frame.origin.x < -(self.bounds.size.width - self.bounds.size.height) ? -(self.bounds.size.width - self.bounds.size.height) : frame.origin.x;
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.indicationLayer.frame = frame;
    [CATransaction commit];
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    _lastDownPoint = [touch locationInView: self];
    self.isMouseDown = YES;
    [super touchesBegan: touches withEvent: event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView: self];
    
    if(CGRectEqualToRect(self.indicationLayer.frame, [self _indicationRect])) {
        if (CGRectContainsPoint(self.bounds, point)) {
            [self setOn: !self.on animated: YES];
        }
    } else {
        CGFloat offx = self.indicationLayer.frame.origin.x;
        BOOL on = offx > -(self.bounds.size.width - self.bounds.size.height) / 2 ? YES : NO;
        [self setOn: on animated: YES];
    }

    self.isMouseDown = NO;
    _lastDownPoint = CGPointZero;
    
    [super touchesEnded: touches withEvent: event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] lastObject];
    CGPoint point = [touch locationInView: self];
    CGFloat offx = point.x - _lastDownPoint.x;
    self.offx = offx;
    _lastDownPoint = point;
    [super touchesMoved: touches withEvent: event];
}
@end
