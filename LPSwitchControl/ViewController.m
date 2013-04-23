//
//  ViewController.m
//  LPSwitchControl
//
//  Created by Penny on 14/03/13.
//  Copyright (c) 2013 Penny. All rights reserved.
//

#import "ViewController.h"
#import "LPSwitch.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LPSwitch *switcher = [[LPSwitch alloc] initWithFrame: CGRectMake(100, 100, 80, 30)];
    switcher.onImage = [UIImage imageNamed: @"1.png"];
    [self.view addSubview: switcher];
    [switcher addTarget: self action: @selector(valueChanged:)];
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame: CGRectMake(100, 200, 60, 30)];
    switchView.tintColor = [UIColor blackColor];
    switchView.thumbTintColor = [UIColor redColor];
    switchView.onTintColor = [UIColor orangeColor];

    
    [self.view addSubview: switchView];
    
}

- (void)valueChanged:(id)sender
{
    NSLog(@"valueChanged");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
