//
//  AM3ViewController.h
//  iHealthDemoCode
//
//  Created by hejiasu on 16/6/30.
//  Copyright © 2016年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AM3ViewController : UIViewController
- (IBAction)scanDevice:(id)sender;
- (IBAction)stopDevice:(id)sender;
- (IBAction)SetUserID:(id)sender;

- (IBAction)SyncActiveData:(id)sender;
- (IBAction)SyncSleepData:(id)sender;
- (IBAction)SyncCurrentActive:(id)sender;
- (IBAction)GetTotoalAlarm:(id)sender;
- (IBAction)SetAlarm:(id)sender;
- (IBAction)DeleteAlarm:(id)sender;
- (IBAction)GetDeviceState:(id)sender;
- (IBAction)GetReminder:(id)sender;
- (IBAction)SetReminder:(id)sender;
- (IBAction)ResetDevice:(id)sender;
- (IBAction)Disconnect:(id)sender;
- (IBAction)GetTimeFormat:(id)sender;
- (IBAction)GetUserInfo:(id)sender;
- (IBAction)SetStateModel:(UIButton *)sender;

- (IBAction)back:(id)sender;

@end
