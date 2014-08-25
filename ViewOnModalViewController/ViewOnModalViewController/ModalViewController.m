//
//  ModalViewController.m
//  ViewOnModalViewController
//
//  Created by heleiwu on 8/24/14.
//  Copyright (c) 2014 heleiwu. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightButton)];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 44.0)];
//        searchBar.backgroundColor = [UIColor redColor];
        self.navigationItem.titleView = searchBar;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) onClickRightButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playAnimation:(id)sender {
    [UIView animateWithDuration:3.0 animations:^{
        CGRect frame = self.lblTitle.frame;
        CGRect superFrame = self.view.frame;
        if (frame.origin.x < superFrame.size.width - frame.size.width) {
            frame.origin.x = superFrame.size.width - frame.size.width;
        } else {
            frame.origin.x = 0;
        }
        
        self.lblTitle.frame = frame;
    } completion:^(BOOL finished){
        if (finished) {
//            [self playAnimation:sender];
        }
    }];
}

@end
