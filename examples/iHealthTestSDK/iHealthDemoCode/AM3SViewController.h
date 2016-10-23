//
//  AM3SViewController.h
//  iHealthDemoCode
//
//  Created by hejiasu on 16/7/6.
//  Copyright © 2016年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AM3SViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)scanDevice:(UIButton *)sender;
- (IBAction)setUserID:(id)sender;


- (IBAction)stopScan:(UIButton *)sender;


- (IBAction)SyncActiveData:(UIButton *)sender;

- (IBAction)SyncStageData:(id)sender;

- (IBAction)commandAM3SResetDevice:(id)sender;
- (IBAction)commandAM3SDisconnect:(id)sender;

- (IBAction)commandAM3SGetTotoalAlarmInfo:(id)sender;

- (IBAction)commandAM3SSetAlarmDictionary:(id)sender;

- (IBAction)commandAM3SDeleteAlarmID:(id)sender;
- (IBAction)commandAM3SGetReminderInfo:(id)sender;
- (IBAction)commandAM3SSetReminderDictionary:(id)sender;
- (IBAction)commandAM3SGetTimeFormatAndNation:(id)sender;
- (IBAction)commandAM3SGetUserInfo:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)setPicture:(id)sender;
- (IBAction)getPicture:(id)sender;

@end
