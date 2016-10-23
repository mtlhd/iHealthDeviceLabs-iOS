//
//  AM3ViewController.m
//  iHealthDemoCode
//
//  Created by hejiasu on 16/6/30.
//  Copyright © 2016年 zhiwei jing. All rights reserved.
//

#import "AM3ViewController.h"
#import "ScanDeviceController.h"
#import "AMHeader.h"
@interface AM3ViewController ()
{
    AM3 *am3Instance;
    HealthUser *myUser;
    NSNumber *userIDNumber;
    NSNumber *randomNumber;
}
@end

@implementation AM3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3Discover:) name:AM3Discover object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3ConnectFailed:) name:AM3ConnectFailed object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForAM3:) name:AM3ConnectNoti object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForAM3:) name:AM3DisConnectNoti object:nil];

    

    [AM3Controller shareIHAM3Controller];

}
- (IBAction)scanDevice:(id)sender {
    ScanDeviceController *scan = [ScanDeviceController commandGetInstance];
    [scan commandScanDeviceType:HealthDeviceType_AM3];    
}

- (IBAction)stopDevice:(id)sender {
    
    ScanDeviceController *scan = [ScanDeviceController commandGetInstance];
    [scan commandStopScanDeviceType:HealthDeviceType_AM3];
}

-(void)deviceAM3Discover:(NSNotification *)info
{
    NSString *serialNub = [[info userInfo]valueForKey:@"SerialNumber"];
    
    
    [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_AM3 andSerialNub:serialNub];
}



-(void)deviceAM3ConnectFailed:(NSNotification *)info
{
    
}

-(void)DeviceDisConnectForAM3:(NSNotification *)info
{
    
}

-(void)DeviceConnectForAM3:(NSNotification *)info
{
    AM3Controller *amController = [AM3Controller shareIHAM3Controller];
    NSArray *amArray = [amController getAllCurrentAM3Instace];
    
    if(amArray.count==1)
    {
        am3Instance = [amArray objectAtIndex:0];
        myUser = [[HealthUser alloc]init];
        myUser.clientID = SDKKey;
        myUser.clientSecret = SDKSecret;
        myUser.userID = YourUserName;
        
        [am3Instance commandAM3CreateUserManageConnectWithUser:myUser withAuthenticationResult:^(UserAuthenResult result) {
            NSLog(@"---UserAuthenResult:%d",result);

        } withCurrentUserID:^(NSInteger serialNub) {
            
            NSLog(@"serialNub:%ld",(long)serialNub);

            userIDNumber = [NSNumber numberWithInteger:serialNub];
            userIDNumber  = @12345678;
            
            [am3Instance commandAM3SyncTime:^(BOOL resetSuc) {
                
                NSLog(@"SyncTimeOk");

                [am3Instance commandAM3SetTimeFormat:^(BOOL resetSuc) {
                    
                    NSLog(@"SetTimeFormatAndNationOk");

                    [am3Instance commandAM3GetDeviceUserID:^(unsigned int userID) {
                        
                        NSLog(@"GetDeviceUserID:%d",userID);
                        myUser.userID = [NSString stringWithFormat:@"%d",userID];

                        
                    } withFromCloudGetUserBinedDeviceMAC:^(NSString *deviceMAC) {
                        
                        NSLog(@"FromCloudGetUserBinedDeviceMAC:%@",deviceMAC);

                        if (userIDNumber.intValue == myUser.userID.intValue)
                        {
                            [self commandAM3SetUserInfo];
                        }
                        else{
                        
                            
                        }
                        
                    } withErrorBlock:^(AM3ErrorID errorID) {
                        
                        NSLog(@"AMErrorID:%d",errorID);

                    }];
                    
                } withErrorBlock:^(AM3ErrorID errorID) {
                    
                    NSLog(@"AMErrorID:%d",errorID);

                }];
                
            } withErrorBlock:^(AM3ErrorID errorID) {
                NSLog(@"AMErrorID:%d",errorID);
            }];
            
        } withErrorBlock:^(AM3ErrorID errorID) {
            
            NSLog(@"AMErrorID:%d",errorID);

        }];
    }
}

- (void)commandAM3SetUserInfo
{
    myUser.age = @12;
    myUser.sex = UserSex_Male;
    myUser.height = @165;
    myUser.weight = @55;
    myUser.bmr = @120;
    myUser.lengthUnit = LengthUnit_Kilometer;
    myUser.activityLevel = @1;
    
    [am3Instance commandAM3SetUserInfo:myUser withUnit:AM3StateUnit_mile withActiveGoal:@10000 withSetUserInfoFinishResult:^(BOOL resetSuc) {
        NSLog(@"FinishResultok");

    } withSetBMR:^(BOOL resetSuc) {
        NSLog(@"SetBMR ok");

    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}


- (IBAction)SetUserID:(id)sender {
    
    [am3Instance commandAM3SetUserID:userIDNumber withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"SetUserIDok");
        [self commandAM3SetUserInfo];

        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}



- (IBAction)SyncActiveData:(id)sender {
    
    [am3Instance commandAM3StartSyncActiveData:^(NSDictionary *startDataDictionary) {
        
        NSLog(@"StartSyncActive --%@",startDataDictionary);
        
    } withActiveHistoryData:^(NSArray *historyDataArray) {
        
        NSLog(@"historyData --%@",historyDataArray);
        
    } withActiveFinishTransmission:^{
        
        NSLog(@"ok");
        
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)SyncSleepData:(id)sender {
    
    [am3Instance commandAM3StartSyncSleepData:^(NSDictionary *startDataDictionary) {
        NSLog(@"StartSyncSleep --%@",startDataDictionary);
        
    } withSleepHistoryData:^(NSArray *historyDataArray) {
        NSLog(@"historyData --%@",historyDataArray);
        
    } withSleepFinishTransmission:^{
        NSLog(@"ok");
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)SyncCurrentActive:(id)sender {
    [am3Instance commandAM3StartSyncCurrentActiveData:^(NSDictionary *activeDictionary) {
        NSLog(@"StartSyncCurrentActive --%@",activeDictionary);
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)GetTotoalAlarm:(id)sender {
    
    [am3Instance commandAM3GetTotoalAlarmInfo:^(NSMutableArray *totoalAlarmArray) {
        
        
        NSLog(@"GetTotoalAlarmInfo %@",totoalAlarmArray);
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}
- (IBAction)SetAlarm:(id)sender {
    
    NSDictionary *tempClockDic = [NSDictionary dictionaryWithObjectsAndKeys:@2,@"AlarmId",@1,@"Sun",[NSDate date],@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
    
    
    [am3Instance commandAM3SetAlarmDictionary:tempClockDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3SetAlarmDictionary ok");
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)DeleteAlarm:(id)sender {
    
    [am3Instance commandAM3DeleteAlarmID:@1 withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3DeleteAlarmID ok");
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)GetDeviceState:(id)sender {
    
    
    [am3Instance commandAM3GetDeviceStateInfo:^(AM3StateInfo queryState) {
        NSLog(@"DeviceStateInfo:%d",queryState);
        
    } withBattery:^(NSNumber *battery) {
        NSLog(@"battery:%d",battery.intValue);
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)GetReminder:(id)sender {
    
    [am3Instance commandAM3GetReminderInfo:^(NSArray *remindInfo) {
        
        NSLog(@"commandAM3GetReminderInfo %@",remindInfo);
        
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}
- (IBAction)SetReminder:(id)sender {
    
    NSDictionary *tempReminderDic = [NSDictionary dictionaryWithObjectsAndKeys:@"00:01",@"Time",@1,@"Switch",nil];
    
    [am3Instance commandAM3SetReminderDictionary:tempReminderDic withFinishResult:^(BOOL resetSuc) {
        
        NSLog(@"SetReminderDictionary ok");
        
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)ResetDevice:(id)sender {
    
    [am3Instance commandAM3ResetDevice:^(BOOL resetSuc) {
        NSLog(@"ResetDevice Ok");
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)Disconnect:(id)sender {
    
    [am3Instance commandAM3Disconnect:^(BOOL resetSuc) {
        
        NSLog(@"commandAM3Disconnect Ok");
        
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)GetTimeFormat:(id)sender {
    
    [am3Instance commandAM3GetTimeFormat:^(AM3TimeFormat timeFormat) {
        
        NSLog(@"commandAM3GetTimeFormatAndNation %u",timeFormat);

    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
    
}

- (IBAction)GetUserInfo:(id)sender {
    
    [am3Instance commandAM3GetUserInfo:^(NSDictionary *userInfo) {
        
        NSLog(@"commandAM3GetUserInfo %@",userInfo);
        
        
    } withErrorBlock:^(AM3ErrorID errorID) {
        
        NSLog(@"AMErrorID:%d",errorID);
        
    }];

}

- (IBAction)SetStateModel:(UIButton *)sender {
    
    [am3Instance commandAM3SetStateModel:AM3StateModel_drive withFinishResult:^(BOOL resetSuc) {
        NSLog(@"commandAM3SetStateModel Ok");

    } withErrorBlock:^(AM3ErrorID errorID) {
        NSLog(@"AMErrorID:%d",errorID);

    }];
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
