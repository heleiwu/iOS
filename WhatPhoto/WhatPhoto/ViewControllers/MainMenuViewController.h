//
//  MainMenuViewController.h
//  WhatPhoto
//
//  Created by heleiwu on 9/8/14.
//  Copyright (c) 2014 heleiwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "UIButton+Badge.h"
@class CustomAlertView;

@interface MainMenuViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSMutableArray *imageArray;
    
    IBOutlet UIView *flashView;
    IBOutlet UIView *modeView;
    IBOutlet UIScrollView *scrollView;
    
    BOOL singleMode;    //单张拍摄
    CustomAlertView *alertView;
}

@property (nonatomic, strong) IBOutlet UIButton *btnTakePhoto;
@property (nonatomic, strong) IBOutlet UIButton *btnBeautify;
@property (nonatomic, strong) IBOutlet UIButton *btnSetting;

@end
