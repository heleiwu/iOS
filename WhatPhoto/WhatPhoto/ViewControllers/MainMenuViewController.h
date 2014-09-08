//
//  MainMenuViewController.h
//  WhatPhoto
//
//  Created by heleiwu on 9/8/14.
//  Copyright (c) 2014 heleiwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *btnTakePhoto;
@property (nonatomic, strong) IBOutlet UIButton *btnBeautify;
@property (nonatomic, strong) IBOutlet UIButton *btnSetting;

@end
