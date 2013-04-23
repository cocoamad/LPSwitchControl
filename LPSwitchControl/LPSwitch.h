//
//  LPSwitch.h
//  LPSwitchControl
//
//  Created by Penny on 15/03/13.
//  Copyright (c) 2013 Penny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPSwitch : UIView
@property (nonatomic, assign) BOOL on;

@property(nonatomic, retain) UIColor *onTintColor;
@property(nonatomic, retain) UIColor *tintColor;
@property(nonatomic, retain) UIColor *thumbTintColor;

@property(nonatomic, retain) UIImage *onImage;
@property(nonatomic, retain) UIImage *offImage;
@property(nonatomic, retain) UIImage *pointImage;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)addTarget:(id)target action:(SEL)action;
@end
