//
//  ViewController.m
//  FullScreenExample
//
//  Created by heleiwu on 8/26/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL showStatusBar;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeft)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRight)];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickLeft {

}

- (void)onClickRight {
    
}

- (IBAction)toggleNavigationBar:(id)sender {
    BOOL show = !self.navigationController.navigationBarHidden;
    [UIView animateWithDuration:0.24 animations:^(void) {
        self.navigationController.navigationBarHidden = show;
        _showStatusBar = show;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return _showStatusBar;
}

@end
