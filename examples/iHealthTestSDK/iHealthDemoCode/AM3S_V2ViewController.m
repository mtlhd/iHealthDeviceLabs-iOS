//
//  AM3S_V2ViewController.m
//  iHealthDemoCode
//
//  Created by user on 16/8/12.
//  Copyright © 2016年 zhiwei jing. All rights reserved.
//

#import "AM3S_V2ViewController.h"
#import "ScanDeviceController.h"
#import "AMHeader.h"
@interface AM3S_V2ViewController ()
{
    AM3S_V2 *am3Instance;
    HealthUser *myUser;
    NSNumber *userIDNumber;
    NSNumber *randomNumber;
}
@end

@implementation AM3S_V2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3SDiscover:) name:AM3SDiscover object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3SConnectFailed:) name:AM3SConnectFailed object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConnectForAM3S:) name:AM3SConnectNoti object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceDisConnectForAM3S:) name:AM3SDisConnectNoti object:nil];
    
    [AM3SController_V2 shareIHAM3SController] ;
    
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
    
    
    AM3SController_V2 *AM3SInstance = [AM3SController_V2 shareIHAM3SController];
    NSArray *amArray = [AM3SInstance getAllCurrentAM3SInstace];
    
    
    if(amArray.count==1)
    {
        am3Instance = [amArray objectAtIndex:0];
        myUser = [[HealthUser alloc]init];
        myUser.clientID = SDKKey;
        myUser.clientSecret = SDKSecret;
        myUser.userID = YourUserName;
        
        [am3Instance commandAM3SCreateUserManageConnectWithUser:myUser withAuthenticationResult:^(UserAuthenResult result) {
            
            NSLog(@"UserAuthenResult:%d",result);
            
        } withCurrentUserID:^(NSInteger serialNub) {
            
            NSLog(@"serialNub:%ld",(long)serialNub);
            
            userIDNumber = [NSNumber numberWithInt:serialNub];
            //            userIDNumber = [NSNumber numberWithInt:12344780];
            
            
            [am3Instance commandAM3SSyncTime:^(BOOL resetSuc) {
                
                NSLog(@"SyncTimeOk");
                
                [am3Instance commandAM3SSetTimeFormatAndNation:^(BOOL timeFormatAndNationSetting) {
                    
                    NSLog(@"SetTimeFormatAndNationOk");
                    
                    
                    [am3Instance commandAM3SGetDeviceUserID:^(unsigned int userID) {
                        
                        NSLog(@"GetDeviceUserID:%d",userID);
                        myUser.userID = [NSString stringWithFormat:@"%d",userID];
                        
                        
                    } withFromCloudGetUserBinedDeviceMAC:^(NSString *deviceMAC) {
                        
                        NSLog(@"FromCloudGetUserBinedDeviceMAC:%@",deviceMAC);
                        
                        if (userIDNumber.intValue == myUser.userID.intValue)
                        {
                            [self commandAM3SSetUserInfo];
                        }
                        else
                        {
                            
                            [am3Instance commandAM3SSetRandomNumber:^(NSString *randomNumString) {
                                
                                NSLog(@"randomNumString:%@",randomNumString);
                                
                                
                                randomNumber = [NSNumber numberWithInt:[randomNumString intValue]];
                                
                                
                            } withErrorBlock:^(AM3SErrorID errorID) {
                                
                                NSLog(@"AMErrorID:%d",errorID);
                                
                            }];
                        }
                        
                        
                    } withErrorBlock:^(AM3SErrorID errorID) {
                        
                        NSLog(@"AMErrorID:%d",errorID);
                        
                    }];
                    
                    
                    
                } withErrorBlock:^(AM3SErrorID errorID) {
                    
                    NSLog(@"AMErrorID:%d",errorID);
                    
                }];
                
            } withErrorBlock:^(AM3SErrorID errorID) {
                
                NSLog(@"AMErrorID:%d",errorID);
                
            }];
            
            
            
        } withErrorBlock:^(AM3SErrorID errorID) {
            
            NSLog(@"AMErrorID:%d",errorID);
            
        }];
    }
}

- (void)commandAM3SSetUserInfo
{
    myUser.age = @12;
    myUser.sex = UserSex_Male;
    myUser.height = @165;
    myUser.weight = @55;
    myUser.bmr = @120;
    myUser.lengthUnit = LengthUnit_Kilometer;
    myUser.activityLevel = @1;
    
    
    [am3Instance commandAM3SSetUserInfo:myUser withUnit:AM3SKmUnit_mile withActiveGoal:@10000  withSetUserInfoFinishResult:^(BOOL resetSuc) {
        NSLog(@"FinishResultok");
        
    } withSetBMR:^(BOOL resetSuc) {
        
        NSLog(@"SetBMR ok");
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}


- (IBAction)setUserID:(id)sender
{
    if ([[NSString stringWithFormat:@"%@",randomNumber] isEqualToString:self.textField.text]) {
        
        
        [am3Instance commandAM3SSetUserID:userIDNumber withFinishResult:^(BOOL resetSuc) {
            
            NSLog(@"SetUserIDok");
            [self commandAM3SSetUserInfo];
            
            
        } withErrorBlock:^(AM3SErrorID errorID) {
            
            NSLog(@"AMErrorID:%d",errorID);
            
        }];
        
    }
}



- (IBAction)SyncActiveData:(UIButton *)sender {
    
    
    [am3Instance commandAM3SStartSyncActiveData:^(NSDictionary *startDataDictionary) {
        
        NSLog(@"StartSyncActive --%@",startDataDictionary);
        
    } withActiveHistoryData:^(NSArray *historyDataArray) {
        
        NSLog(@"historyData --%@",historyDataArray);
        
    } withActiveFinishTransmission:^{
        
        NSLog(@"ok");
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
    
    
}

- (IBAction)SyncSleepData:(id)sender {
    
    [am3Instance commandAM3SStartSyncSleepData:^(NSDictionary *startDataDictionary) {
        NSLog(@"StartSyncSleep --%@",startDataDictionary);
        
    } withSleepHistoryData:^(NSArray *historyDataArray) {
        NSLog(@"historyData --%@",historyDataArray);
        
    } withSleepFinishTransmission:^{
        NSLog(@"ok");
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)SyncCurrentActive:(id)sender {
    
    
    [am3Instance commandAM3SStartSyncCurrentActiveData:^(NSDictionary *activeDictionary) {
        NSLog(@"StartSyncCurrentActive --%@",activeDictionary);
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
    
}

- (IBAction)SyncStageData:(id)sender {
    
    [am3Instance commandAM3SStartSyncStageData:^(NSArray *measureDataArray) {
        NSLog(@"historyData --%@",measureDataArray);
        
    } withStageDataFinishTransmission:^(BOOL resetSuc) {
        NSLog(@"ok");
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
    
}

- (IBAction)commandAM3SGetDeviceStateInfo:(id)sender {
    [am3Instance commandAM3SGetDeviceStateInfo:^(AM3SQueryState queryState) {
        NSLog(@"DeviceStateInfo:%d",queryState);
        
    } withBattery:^(NSNumber *battery) {
        NSLog(@"battery:%d",battery.intValue);
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)commandAM3SResetDevice:(id)sender {
    [am3Instance commandAM3SResetDevice:^(BOOL resetSuc) {
        NSLog(@"ResetDevice Ok");
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)commandAM3SDisconnect:(id)sender {
    
    [am3Instance commandAM3SDisconnect:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SDisconnect Ok");
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)commandAM3SGetTotoalAlarmInfo:(id)sender {
    
    [am3Instance commandAM3SGetTotoalAlarmInfo:^(NSMutableArray *totoalAlarmArray) {
        
        
        NSLog(@"GetTotoalAlarmInfo %@",totoalAlarmArray);
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
    
    
}

- (IBAction)commandAM3SSetAlarmDictionary:(id)sender {
    
    NSDictionary *tempClockDic = [NSDictionary dictionaryWithObjectsAndKeys:@2,@"AlarmId",@1,@"Sun",[NSDate date],@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
    
    
    [am3Instance commandAM3SSetAlarmDictionary:tempClockDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SSetAlarmDictionary ok");
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)commandAM3SDeleteAlarmID:(id)sender {
    
    [am3Instance commandAM3SDeleteAlarmID:@1 withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SDeleteAlarmID ok");
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)commandAM3SGetReminderInfo:(id)sender {
    
    [am3Instance commandAM3SGetReminderInfo:^(NSArray *remindInfo) {
        
        NSLog(@"commandAM3SGetReminderInfo %@",remindInfo);
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)commandAM3SSetReminderDictionary:(id)sender {
    
    NSDictionary *tempReminderDic = [NSDictionary dictionaryWithObjectsAndKeys:@"00:01",@"Time",@1,@"Switch",nil];
    
    [am3Instance commandAM3SSetReminderDictionary:tempReminderDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"SetReminderDictionary ok");
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
    
}

- (IBAction)commandAM3SGetTimeFormatAndNation:(id)sender {
    
    [am3Instance commandAM3SGetTimeFormatAndNation:^(AM3STimeFormatAndNation timeFormatAndNation) {
        
        NSLog(@"commandAM3SGetTimeFormatAndNation %u",timeFormatAndNation);
        
        
    } withErrorBlock:^(AM3SErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];
}

- (IBAction)commandAM3SGetUserInfo:(id)sender {
    
  
    
    [am3Instance commandAM3SGetUserInfo:^(NSDictionary *userInfo) {
        NSLog(@"userInfo:%@",userInfo);

    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)setPicture:(UIButton *)sender {
    
    [am3Instance commandAM3SSetPicture:AM3SPicture_one withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"resetSuc:%hhd",resetSuc);

    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)getPicture:(UIButton *)sender {
    
    [am3Instance commandAM3SGetPicture:^(AM3SPicture picture) {
        
        NSLog(@"picture:%u",picture);

    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)setBMR:(UIButton *)sender {
    
    [am3Instance commandAM3SSetBMR:@11 withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"resetSuc:%u",resetSuc);

    } withErrorBlock:^(AM3SErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];}



- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
