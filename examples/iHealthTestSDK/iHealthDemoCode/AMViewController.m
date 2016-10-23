//
//  AMViewController.m
//  iHealthDemoCode
//
//  Created by zhiwei jing on 14-9-23.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import "AMViewController.h"
#import "AM4ViewController.h"
#import "AM3ViewController.h"
#import "AM3SViewController.h"
#import "AM3S_V2ViewController.h"
@interface AMViewController ()

@end

@implementation AMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)pushAM4:(UIButton *)sender {
    
    
    AM4ViewController *am = [[AM4ViewController alloc]init];
    [self presentViewController:am animated:YES completion:nil];
}

- (IBAction)pushAM3:(UIButton *)sender {
    
    AM3ViewController *am = [[AM3ViewController alloc]init];
    [self presentViewController:am animated:YES completion:nil];
}

- (IBAction)pushAM3S:(UIButton *)sender {
    
    AM3SViewController *am = [[AM3SViewController alloc]init];
    [self presentViewController:am animated:YES completion:nil];
}

- (IBAction)pushAM3S_V2:(UIButton *)sender {
    
    AM3S_V2ViewController *am = [[AM3S_V2ViewController alloc]init];
    [self presentViewController:am animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
