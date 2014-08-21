//
//  ViewController.m
//  CoordinateSystemExample
//
//  Created by heleiwu on 8/21/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshOrientationUI:[[UIApplication sharedApplication] statusBarOrientation]];
    [self refreshAllLabelCoordinate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self refreshOrientationUI:toInterfaceOrientation];
    [self refreshAllLabelCoordinate];
}

//UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
//UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
//UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
//UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft

- (void)refreshOrientationUI:(UIInterfaceOrientation)orientation {
    
    NSString *orientationName;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            orientationName = @"UIInterfaceOrientationPortrait";
            break;
        
        case UIInterfaceOrientationPortraitUpsideDown:
            orientationName = @"UIInterfaceOrientationPortraitUpsideDown";
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            orientationName = @"UIInterfaceOrientationLandscapeLeft";
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            orientationName = @"UIInterfaceOrientationLandscapeRight";
            break;
            
        default:
            break;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ \n %@", orientationName, self.view];
    [_lblOrientation setText:title];
}

- (void)refreshAllLabelCoordinate {
    NSArray *lblArray = @[_lblDownLeft, _lblDownRight, _lblUpLeft, _lblUpRight];
    for (UILabel *label in lblArray) {
        [self refreshLabelCoordinate:label];
    }
}

- (void)refreshLabelCoordinate:(UILabel *)label{
    [label setText:@"test"];
    [label setText:[NSString stringWithFormat:@"%@", label]];
}

@end
