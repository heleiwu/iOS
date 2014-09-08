//
//  MainMenuViewController.m
//  WhatPhoto
//
//  Created by heleiwu on 9/8/14.
//  Copyright (c) 2014 heleiwu. All rights reserved.
//

#import "MainMenuViewController.h"
#import "PhotoEditingViewController.h"
#import "UIView+RoundCorner.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewWillAppear:(BOOL)animated {
    [self.btnBeautify setRoundCorner:5.0];
    [self.btnTakePhoto setRoundCorner:5.0];
    [self.btnSetting setRoundCorner:5.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)onClickBeautify:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)onClickTakePhoto:(id)sender {

}

- (IBAction)onClickSetting:(id)sender {

}

#pragma mark - UIImagePickerControllerDelegate
// UIImagePickerControllerOriginalImage
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoEditingViewController *photoEditing = [[PhotoEditingViewController alloc] initWithNibName:@"PhotoEditingViewController" bundle:nil];
    photoEditing.selImage = gotImage;
    [picker pushViewController:photoEditing animated:YES];
}

@end
