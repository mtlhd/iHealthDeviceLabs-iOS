//
//  AM3SViewController.m
//  iHealthDemoCode
//
//  Created by hejiasu on 16/7/6.
//  Copyright © 2016年 zhiwei jing. All rights reserved.
//

#import "AM3SViewController.h"
#import "ScanDeviceController.h"
#import "AMHeader.h"
@interface AM3SViewController ()
{
    AM3S *AM3SInstance;
    HealthUser *myUser;
    NSNumber *userIDNumber;
    
    
    NSNumber *userIDSerialNub;

    NSNumber *randomNumber;
}
@end

@implementation AM3SViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3SDiscover:) name:AM3SDiscover object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3SConnectFailed:) name:AM3SConnectFailed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConnectForAM3S:) name:AM3SConnectNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceDisConnectForAM3S:) name:AM3SDisConnectNoti object:nil];
    
    [AM3SController shareIHAM3SController] ;
    
}

- (IBAction)scanDevice:(UIButton *)sender {
    
    ScanDeviceController *scan = [ScanDeviceController commandGetInstance];
    [scan commandScanDeviceType:HealthDeviceType_AM3S];
}



- (IBAction)stopScan:(UIButton *)sender {
    
    ScanDeviceController *scan = [ScanDeviceController commandGetInstance];
    [scan commandStopScanDeviceType:HealthDeviceType_AM3S];
}


-(void)deviceAM3SDiscover:(NSNotification *)info
{
    NSString *serialNub = [[info userInfo]valueForKey:@"SerialNumber"];
    
    
    [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_AM3S andSerialNub:serialNub];
}

-(void)deviceAM3SConnectFailed:(NSNotification *)info
{
    
}


-(void)deviceDisConnectForAM3S:(NSNotification *)info
{
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    
}




-(void)deviceConnectForAM3S:(NSNotification *)DeviceName
{
    
    AM3SController *amController = [AM3SController shareIHAM3SController];
    NSArray *amArray = [amController getAllCurrentAM3SInstace];
    
    
    if(amArray.count==1)
    {
        AM3SInstance = [amArray objectAtIndex:0];
        myUser = [[HealthUser alloc]init];
        myUser.clientID = SDKKey;
        myUser.clientSecret = SDKSecret;
        myUser.userID = YourUserName;
        
//        _disposeAuthenticationBlock = disposeAuthenticationBlock;//认证结果
//        _currentSerialNub = serialNub;//用户ID
//        _disposeAM3SAskUserID = disposeAskUserID;//AM里的ID
//        _disposeBinedAMSerialNubBlock = binedSerialnub;//要绑定的AM-MAC
//        _disposeCurrentSerialNubBlock = currentSerialNub;//当前连上AM -MAC
        
        [AM3SInstance commandCreateUserManageConnectWithUser:myUser Authentication:^(UserAuthenResult result) {
            NSLog(@"1111-UserAuthenResult:%d",result);

        } currentUserSerialNub:^(NSInteger serialNub) {
            
            NSLog(@"2222-serialNub:%ld",(long)serialNub);

            userIDNumber = [NSNumber numberWithInt:serialNub];

            
        } amUser:^(unsigned int userID) {
            
            NSLog(@"333--userID:%ld",(long)userID);
            userIDSerialNub = [NSNumber numberWithInt:userID];

            
        } binedAMSerialNub:^(NSString *binedSerialNub) {
            
            NSLog(@"444--binedSerialNub:%ld",(long)binedSerialNub);
            
            if ([userIDNumber integerValue] == [userIDSerialNub integerValue])
            {
                
                [self commandAM3SSetUserInfo];
                
            }
            else{
                [AM3SInstance commandAM3SSetRandomNumber:^(BOOL resetSucSetting) {
                    NSLog(@"RandomNumber --%hhd",resetSucSetting);
                } withErrorBlock:^(AM3SErrorID errorID) {
                    NSLog(@"AMErrorID:%d",errorID);
                }];
            }

            
        } currentSerialNub:^(NSString *currentSerialNub) {
            
            NSLog(@"555---currentSerialNub:%ld",(long)currentSerialNub);

            
            
        } DisposeErrorBlock:^(AM3SErrorID errorID) {
            
            NSLog(@"666---AMErrorID:%d",errorID);

        }];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (IBAction)setUserID:(id)sender
{
    if ([[NSString stringWithFormat:@"%@",self.textField.text] isEqualToString:self.textField.text]) {
        
        [AM3SInstance commandSetAM3SUserID:userIDNumber withRandom:AM3SInstance.randomString DisposeBlock:^(BOOL resetSuc) {
            
            NSLog(@"SetUserIDok");

            [self commandAM3SSetUserInfo];

            
        } DisposeErrorBlock:^(AM3SErrorID errorID) {
            
            NSLog(@"AMErrorID:%d",errorID);

        }];
    }
}


- (void)commandAM3SSetUserInfo
{
    myUser.birthday = [NSDate dateWithTimeIntervalSince1970:0];
    myUser.sex = UserSex_Male;
    myUser.height = @165;
    myUser.weight = @55;
    myUser.bmr = @120;
    myUser.lengthUnit = LengthUnit_Kilometer;
    myUser.activityLevel = @1;
    
    
    
    [AM3SInstance commandSyncUserInfoWithUser:myUser andGoal:@1000 DisposeStateInfo:^(AM3SQueryState queryState) {
        
        NSLog(@"111--%u",queryState);
        
    } DisposeBattery:^(NSNumber *battery) {
        
        NSLog(@"22---%@",battery);
        
    } DisposeBlock:^(BOOL resetSuc) {
        NSLog(@"33--%hhd",resetSuc);
        
    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"33--%u",errorID);
        
    }];
    
}

- (IBAction)commandAM3SGetTotoalAlarmInfo:(id)sender {
    
    [AM3SInstance commandQueryAlarmInfo:^(NSMutableArray *totoalAlarmArray) {
        NSLog(@"GetTotoalAlarmInfo %@",totoalAlarmArray);

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)commandAM3SSetAlarmDictionary:(id)sender {
    
    NSDictionary *tempClockDic = [NSDictionary dictionaryWithObjectsAndKeys:@2,@"AlarmId",@1,@"Sun",[NSDate date],@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
    
    [AM3SInstance commandSetAlarmWithAlarmDictionary:tempClockDic DisposeResultBlock:^(BOOL resetSuc) {
        NSLog(@"commandAM3SSetAlarmDictionary ok");

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)commandAM3SDeleteAlarmID:(id)sender {
    
    [AM3SInstance commandDeleteAlarmViaID:@1 DisposeResultBlock:^(BOOL resetSuc) {
        NSLog(@"commandAM3SDeleteAlarmID ok");

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)commandAM3SGetReminderInfo:(id)sender {
    
    [AM3SInstance commandQueryReminder:^(NSArray *remindInfo) {
        NSLog(@"commandAM3SGetReminderInfo %@",remindInfo);

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)commandAM3SSetReminderDictionary:(id)sender {
    
    NSDictionary *tempReminderDic = [NSDictionary dictionaryWithObjectsAndKeys:@"00:01",@"Time",@1,@"Switch",nil];
    
    [AM3SInstance commandSetReminderwithReminderDictionary:tempReminderDic DisposeResultBlock:^(BOOL resetSuc) {
        NSLog(@"SetReminderDictionary ok");

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)commandAM3SDisconnect:(id)sender {
    
    [AM3SInstance commandDisconnectDisposeBlock:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SDisconnect Ok");

        
    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)SyncStageData:(id)sender {
    
    [AM3SInstance commandSetSyncsportCount:^(NSNumber *sportCount) {
        NSLog(@"historyData --%d",sportCount.integerValue);

    } DisposeMeasureData:^(NSArray *measureDataArray) {
        NSLog(@"historyData --%@",measureDataArray);

    } disposeFinishMeasure:^(BOOL finishUpload) {
        NSLog(@"ok");

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)SyncActiveData:(UIButton *)sender {
    
    
    [AM3SInstance commandSyncAllAM3SData:^(NSDictionary *startDataDictionary) {
        NSLog(@"StartSyncSleep --%@",startDataDictionary);

    } DisposeProgress:^(NSNumber *progress) {
        
    } historyData:^(NSArray *historyDataArray) {
        NSLog(@"historyData --%@",historyDataArray);

    } FinishTransmission:^{
        NSLog(@"ok");

    } startsleepdata:^(NSDictionary *startDataDictionary) {
        NSLog(@"StartSyncSleep --%@",startDataDictionary);

    } DisposeSleepProgress:^(NSNumber *progress) {
        
    } sleephistoryData:^(NSArray *historyDataArray) {
        NSLog(@"historyData --%@",historyDataArray);

    } FinishSleepTransmission:^{
        NSLog(@"ok");

    } CurrentActiveInfo:^(NSDictionary *activeDictionary) {
        NSLog(@"StartSyncCurrentActive --%@",activeDictionary);

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    } AM3SIsOnTransmission:^(BOOL isTransmiting) {
        
    } SleepIsOnTransmission:^(BOOL isTransmiting) {
        
    }];
}


- (IBAction)commandAM3SGetUserInfo:(id)sender {
    
    [AM3SInstance commandQueryUserInfo:^(BOOL resetSuc) {
        
    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    } DisposeUserInfo:^(NSDictionary *userInfo) {
        NSLog(@"commandAM3SGetUserInfo %@",userInfo);

    }];
}


- (IBAction)commandAM3SResetDevice:(id)sender {
    
    [AM3SInstance commandResetDeviceDisposeResultBlock:^(BOOL resetSuc) {
        NSLog(@"ResetDevice Ok");

    } DisposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}


- (IBAction)commandAM3SGetTimeFormatAndNation:(id)sender {
    
    [AM3SInstance commandQueryTimeFormat:^(AM3STimeFormatAndNation timeFormat) {
        NSLog(@"commandAM3SGetTimeFormatAndNation %u",timeFormat);

    } disposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setPicture:(id)sender {
    
    [AM3SInstance commandAM3SSetPicture:AM3SPicture_one resultBlock:^(BOOL resetSucSetting) {
        NSLog(@"resetSucSetting:%d",resetSucSetting);

    } disposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)getPicture:(id)sender {
    
    [AM3SInstance commandAM3SQueryPicture:^(AM3SPicture picture) {
        NSLog(@"picture:%d",picture);

    } disposeErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}





















@end
