//
//  AM3S_V2ViewController.h
//  iHealthDemoCode
//
//  Created by user on 16/8/12.
//  Copyright © 2016年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AM3S_V2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)scanDevice:(UIButton *)sender;
- (IBAction)setUserID:(id)sender;
- (IBAction)stopScan:(UIButton *)sender;
- (IBAction)SyncActiveData:(UIButton *)sender;
- (IBAction)SyncSleepData:(id)sender;
- (IBAction)SyncCurrentActive:(id)sender;
- (IBAction)SyncStageData:(id)sender;
- (IBAction)commandAM3SGetDeviceStateInfo:(id)sender;
- (IBAction)commandAM3SResetDevice:(id)sender;
- (IBAction)commandAM3SDisconnect:(id)sender;
- (IBAction)commandAM3SGetTotoalAlarmInfo:(id)sender;
- (IBAction)commandAM3SSetAlarmDictionary:(id)sender;
- (IBAction)commandAM3SDeleteAlarmID:(id)sender;
- (IBAction)commandAM3SGetReminderInfo:(id)sender;
- (IBAction)commandAM3SSetReminderDictionary:(id)sender;
- (IBAction)commandAM3SGetTimeFormatAndNation:(id)sender;
- (IBAction)commandAM3SGetUserInfo:(id)sender;
- (IBAction)setPicture:(UIButton *)sender;
- (IBAction)getPicture:(UIButton *)sender;
- (IBAction)setBMR:(UIButton *)sender;
- (IBAction)back:(id)sender;
@end
