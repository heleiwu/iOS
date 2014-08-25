//
//  ViewController.m
//  ViewOnModalViewController
//
//  Created by heleiwu on 8/23/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "ModalViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showModalViewController:(id)sender {
    ModalViewController *modal = [[ModalViewController alloc] initWithNibName:@"ModalViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:modal];
    [nav setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
