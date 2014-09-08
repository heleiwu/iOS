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

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define GET_IMAGE(__NAME__,__TYPE__)    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:__NAME__ ofType:__TYPE__]]


@interface MainMenuViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, retain) UIImagePickerController *imagePickerController;
- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation MainMenuViewController
@synthesize imagePickerController;

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
    /*camera photos*/
    imageArray = [[NSMutableArray alloc] init];
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
    
    singleMode = YES;
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    self.imagePickerController = picker;
    [self setupImagePicker:sourceType];
    
    picker = nil;
    
    UIToolbar *cameraOverlayView = (UIToolbar *)self.imagePickerController.cameraOverlayView;
    UIBarButtonItem *doneItem = [[cameraOverlayView items] lastObject];
    [doneItem setTitle:@"取消"];
    
    [self presentModalViewController:self.imagePickerController animated:YES];
    
    

}

- (IBAction)onClickSetting:(id)sender {

}



/*take photos selctor*/
//这里是主要函数  imagePickerViewController interface toolbar主要参数
- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 不使用系统的控制界面
        self.imagePickerController.showsCameraControls = NO;
        
        UIToolbar *controlView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        //闪光灯
        UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        flashBtn.frame = CGRectMake(0, 0, 35, 35);
        flashBtn.showsTouchWhenHighlighted = YES;
        flashBtn.tag = 100;
        [flashBtn setImage:GET_IMAGE(@"camera_flash_auto.png", nil) forState:UIControlStateNormal];
        [flashBtn addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *flashItem = [[UIBarButtonItem alloc] initWithCustomView:flashBtn];
        if (isPad) {
            //ipad,禁用闪光灯
            flashItem.enabled = NO;
        }
        
        //拍照
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(0, 0, 35, 35);
        cameraBtn.showsTouchWhenHighlighted = YES;
        [cameraBtn setImage:GET_IMAGE(@"camera_icon.png", nil) forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(stillImage:) forControlEvents:UIControlEventTouchUpInside];
        [cameraBtn badgeNumber:-1];
        UIBarButtonItem *takePicItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
        
        //摄像头切换
        UIButton *cameraDevice = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraDevice.frame = CGRectMake(0, 0, 35, 35);
        cameraDevice.showsTouchWhenHighlighted = YES;
        [cameraDevice setImage:GET_IMAGE(@"camera_mode.png", nil) forState:UIControlStateNormal];
        [cameraDevice addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cameraDeviceItem = [[UIBarButtonItem alloc] initWithCustomView:cameraDevice];
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            //判断是否支持前置摄像头
            cameraDeviceItem.enabled = NO;
        }
        
        //取消、完成
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered
                                                                    target:self action:@selector(doneAction)];
        
        //模式：单张、多张
        UIButton *modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        modeBtn.frame = CGRectMake(0, 0, 35, 35);
        modeBtn.showsTouchWhenHighlighted = YES;
        modeBtn.tag = 101;
        [modeBtn setImage:GET_IMAGE(@"camera_set.png", nil) forState:UIControlStateNormal];
        [modeBtn addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *modeItem = [[UIBarButtonItem alloc] initWithCustomView:modeBtn];
        
        //空item
        UIBarButtonItem *spItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:flashItem,modeItem,spItem,takePicItem,spItem,cameraDeviceItem,doneItem, nil];
        [controlView setItems:items];
        
        self.imagePickerController.cameraOverlayView = controlView;
        
        controlView = nil;
    }
}

//拍照
- (void)stillImage:(id)sender
{
    [self.imagePickerController takePicture];
}

//完成、取消
- (void)doneAction
{
    [self imagePickerControllerDidCancel:self.imagePickerController];
}


#pragma mark - UIImagePickerController回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (imageArray.count) {
//        [self refreshImage];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //保存相片到数组，这种方法不可取,会占用过多内存
    //如果是一张就无所谓了，到时候自己改
    if (picker == self.imagePickerController) {
        [imageArray addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
        
        UIImage *image = [info
                          objectForKey:@"UIImagePickerControllerOriginalImage"];
        
    
        image = [self fixOrientation:image];
        // Save the image to the album
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        
        if (singleMode) {
            [picker dismissViewControllerAnimated:YES completion:nil];
            //        [self refreshImage];
        }
        else if (imageArray.count == 1) {
            //多张拍摄,不必每次都执行
            UIBarButtonItem *flashItem = [[(UIToolbar *)self.imagePickerController.cameraOverlayView items] lastObject];
            flashItem.title = @"完成";
        }
        
        
        
        
        
        UIToolbar *view = (UIToolbar *)self.imagePickerController.cameraOverlayView;
        UIBarButtonItem *cameraItem = [[view items] objectAtIndex:3];
        [(UIButton *)cameraItem.customView setBadge:imageArray.count ];
    } else {
    
        UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        PhotoEditingViewController *photoEditing = [[PhotoEditingViewController alloc] initWithNibName:@"PhotoEditingViewController" bundle:nil];
        photoEditing.selImage = gotImage;
        [picker pushViewController:photoEditing animated:YES];
    
    }
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:
(NSError *)error contextInfo:(void *)contextInfo
{
    // Handle the end of the image write process
    if (!error)
        NSLog(@"Image written to photo album");
    else
        NSLog(@"Error writing to photo album: %@",
              [error localizedDescription]);
}


#pragma mark - UIImagePickerControllerDelegate

//// UIImagePickerControllerOriginalImage
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    PhotoEditingViewController *photoEditing = [[PhotoEditingViewController alloc] initWithNibName:@"PhotoEditingViewController" bundle:nil];
//    photoEditing.selImage = gotImage;
//    [picker pushViewController:photoEditing animated:YES];
//}



- (UIImage *)fixOrientation: (UIImage *)image{
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark - button actions
//弹出选择
- (void)pushButton:(UIButton *)sender
{
    UIView *contentView = nil;
    if (sender.tag == 100) {  /*闪光灯*/
        //闪光灯
        contentView = flashView;
        UIButton *button = (UIButton *)[flashView viewWithTag:self.imagePickerController.cameraFlashMode+100];
        button.enabled = NO;
    }
    else {  /*单张、多张连拍*/
        //模式
        //        contentView = modeView;
        
        singleMode = !singleMode;
        
        
    }
    
    //    alertView = [[CustomAlertView alloc] initWithContentView:contentView
    //                                                       title:nil
    //                                                     message:nil
    //                                                    delegate:nil
    //                                           cancelButtonTitle:@"Cancel"
    //                                           otherButtonTitles:nil];
    //    [alertView show];
}

@end
