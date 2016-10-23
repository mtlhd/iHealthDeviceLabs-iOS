//
//  UpdateDeviceViewController.m
//  iHealthDemoCode
//
//  Created by daiqingquan on 16/8/14.
//  Copyright © 2016年 zhiwei jing. All rights reserved.
//

#import "UpdateDeviceViewController.h"
#import "SDKUpdateDevice.h"
#import "POHeader.h"
#import "AMHeader.h"
#import "ScanDeviceController.h"



@interface UpdateDeviceViewController ()
{
    NSMutableArray *PO3discoverDevices;
    
    NSMutableArray *AM3SdiscoverDevices;
    
    NSMutableArray *AM4SdiscoverDevices;
    
    NSMutableArray *HS4discoverDevices;
}

@end


@implementation UpdateDeviceViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    PO3discoverDevices=[[NSMutableArray alloc] init];
    
    AM3SdiscoverDevices=[[NSMutableArray alloc] init];
    
    AM4SdiscoverDevices=[[NSMutableArray alloc] init];
    
    HS4discoverDevices=[[NSMutableArray alloc] init];
    
//    [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_PO3];
    
    [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_AM3S];
//
//    [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_AM4];

//    [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_HS4];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForPO3:) name:PO3ConnectNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(devicePO3Discover:) name:PO3Discover object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3SDiscover:) name:AM3SDiscover object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConnectForAM3S:) name:AM3SConnectNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM4Discover:) name:AM4Discover object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceConnectForAM4:) name:AM4ConnectNoti object:nil];
    [AM4Controller shareIHAM4Controller] ;

    
    [AM3SController shareIHAM3SController] ;
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(devicePO3ConnectFailed:) name:PO3DisConnectNoti object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(devicePO3ConnectFailed:) name:PO3ConnectFailed object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceAM3ConnectFailed:) name:AM3ConnectFailed object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForAM3:) name:AM3DisConnectNoti object:nil];
    

    
   

}

- (IBAction)getUpdateState:(id)sender{


    [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateModuleState:^(NSNumber *updateModuleState) {
        
        NSLog(@"UpdateModuleState%@",updateModuleState);
        
    } DisposeErrorBlock:^(UpdateDeviceError errorID) {
        
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

-(void)deviceAM4Discover:(NSNotification *)info
{
    NSString *serialNub = [[info userInfo]valueForKey:@"SerialNumber"];
    
    if([serialNub isEqualToString:@"004D3207903C"]){
    
          [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_AM4 andSerialNub:serialNub];
    }
    
    
  
}

-(void)deviceConnectForAM4:(NSNotification *)DeviceName
{
    
    AM4Controller *amController = [AM4Controller shareIHAM4Controller];
    NSArray *amArray = [amController getAllCurrentAM4Instace];
    
    
        AM4*am4Instance = [amArray objectAtIndex:0];
      
    
    {
        
        [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:am4Instance.currentUUID DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
            
            NSLog(@"updateVersionDic:%@",updateVersionDic);
            
            [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:am4Instance.currentUUID DownloadFirmwareStart:^{
                
                NSLog(@"StartUpdate");
                
                
            } DisposeDownloadFirmwareFinish:^{
                
                NSLog(@"FinishUpdate");
                
            } DisposeUpdateProgress:^(NSNumber *progress) {
                
                NSLog(@"progress%@",progress);
                
            } DisposeUpdateResult:^(NSNumber *updateResult) {
                
                NSLog(@"updateResult%@",updateResult);
                
            } TransferSuccess:^(NSNumber *transferSuccess) {
                
                NSLog(@"transferSuccess%@",transferSuccess);
                
            } DisposeErrorBlock:^(UpdateDeviceError errorID) {
                
                NSLog(@"UpdateDeviceError%u",errorID);
            }];
            
            
            
        } DisposeErrorBlock:^(UpdateDeviceError errorID) {
            
        }];
    }
    
}

-(void)devicePO3ConnectFailed:(NSNotification*)info {
    
    NSLog(@"conncet fail:%@",[info userInfo]);
    NSString *connectSeriaNub=[[info userInfo]objectForKey:@"SerialNumber"];
    NSString *connectID=[[info userInfo]objectForKey:@"ID"];
    for (NSDictionary *discoverDevice in PO3discoverDevices) {
        NSString *serialNub=[[PO3discoverDevices objectAtIndex:0]objectForKey:@"SerialNumber"];
        NSString *ID=[[PO3discoverDevices objectAtIndex:0]objectForKey:@"ID"];
        if (serialNub!=nil&& [serialNub isEqualToString:connectSeriaNub]) {
            [PO3discoverDevices removeObject:discoverDevice];
            break;
            
        } else if(ID!=nil&& [ID isEqualToString:connectID]){
            [PO3discoverDevices removeObject:discoverDevice];
            break;
            
        }
    }
    
     [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_PO3];
    
}




-(void)DeviceConnectForPO3:(NSNotification*)info
{
    PO3Controller *po3Controller = [PO3Controller shareIHPO3Controller];
    NSArray *po3Array = [po3Controller getAllCurrentPO3Instace];
    NSLog(@"connected device：%@",[info userInfo]);
    NSString *connectSeriaNub=[[info userInfo]objectForKey:@"SerialNumber"];
    NSString *connectID=[[info userInfo]objectForKey:@"ID"];
    //remove device from discoverDevices
    for (NSDictionary *discoverDevice in PO3discoverDevices) {
        NSString *serialNub=[[PO3discoverDevices objectAtIndex:0]objectForKey:@"SerialNumber"];
        NSString *ID=[[PO3discoverDevices objectAtIndex:0]objectForKey:@"ID"];
        if (serialNub!=nil&& [serialNub isEqualToString:connectSeriaNub]) {
            [PO3discoverDevices removeObject:discoverDevice];
            break;
        } else if(ID!=nil&& [ID isEqualToString:connectID]){
            [PO3discoverDevices removeObject:discoverDevice];
            break;
        }
    }
    
    if(po3Array.count>0)
    {
        PO3 *po3Instance = [po3Array objectAtIndex:0];
        HealthUser *myUser = [[HealthUser alloc]init];
        
        myUser.clientID = SDKKey;
        myUser.clientSecret = SDKSecret;
        myUser.userID = YourUserName;
        NSArray *versionArray = [po3Instance.firmwareVersion componentsSeparatedByString:@"."];
        
        if ([versionArray count]==3)
        {
            int version1 = [[versionArray objectAtIndex:0] intValue];
            int version2 = [[versionArray objectAtIndex:1] intValue];
            int version3 = [[versionArray objectAtIndex:2] intValue];
            int versionSum = version1*100+version2*10+version3;
            
            if (versionSum>=200) {
                
                [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:po3Instance.currentUUID DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
                    
                    NSLog(@"updateVersionDic:%@",updateVersionDic);
                    
                    [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:po3Instance.currentUUID DownloadFirmwareStart:^{
                        
                        NSLog(@"StartUpdate");
                        
                        
                    } DisposeDownloadFirmwareFinish:^{
                        
                        NSLog(@"FinishUpdate");
                        
                    } DisposeUpdateProgress:^(NSNumber *progress) {
                        
                        NSLog(@"progress%@",progress);
                        
                    } DisposeUpdateResult:^(NSNumber *updateResult) {
                        
                        NSLog(@"updateResult%@",updateResult);
                        
                    } TransferSuccess:^(NSNumber *transferSuccess) {
                        
                        NSLog(@"transferSuccess%@",transferSuccess);
                        
                         [[ScanDeviceController commandGetInstance]commandScanDeviceType:HealthDeviceType_PO3];
                        
                    } DisposeErrorBlock:^(UpdateDeviceError errorID) {
                        
                        NSLog(@"UpdateDeviceError%u",errorID);
                    }];
                    
                    
                    
                } DisposeErrorBlock:^(UpdateDeviceError errorID) {
                    
                }];
            }
        }
        
    }
    
    
}

-(void)devicePO3Discover:(NSNotification*)info {
    
    NSLog(@"Disover:%@",[info userInfo]);
    for (NSDictionary *discoversDevice in PO3discoverDevices) {
        if ([[info userInfo] isEqualToDictionary:discoversDevice]) {
            return;
        }
    }
    [PO3discoverDevices addObject:[info userInfo]];
    
    NSString *serialNub=[[PO3discoverDevices objectAtIndex:0]objectForKey:@"SerialNumber"];
    
    NSString *ID=[[PO3discoverDevices objectAtIndex:0]objectForKey:@"ID"];
    
    if (serialNub!=nil) {
        [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_PO3 andSerialNub:serialNub];
        
    } else {
        [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_PO3 andSerialNub:ID];
        
    }
    
    
}

-(void)deviceAM3SDiscover:(NSNotification *)info
{
    NSLog(@"Disover:%@",[info userInfo]);
    for (NSDictionary *discoversDevice in AM3SdiscoverDevices) {
        if ([[info userInfo] isEqualToDictionary:discoversDevice]) {
            return;
        }
    }
    [AM3SdiscoverDevices addObject:[info userInfo]];
    
    NSString *serialNub=[[AM3SdiscoverDevices objectAtIndex:0]objectForKey:@"SerialNumber"];
    
    NSString *ID=[[AM3SdiscoverDevices objectAtIndex:0]objectForKey:@"ID"];
    
    if (serialNub!=nil) {
        [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_AM3S andSerialNub:serialNub];
        
    } else {
        [[ConnectDeviceController commandGetInstance]commandContectDeviceWithDeviceType:HealthDeviceType_AM3S andSerialNub:ID];
        
    }

}

-(void)deviceConnectForAM3S:(NSNotification *)info
{
    AM3SController *am3sController = [AM3SController shareIHAM3SController];
    NSArray *am3sArray = [am3sController getAllCurrentAM3SInstace];
    NSLog(@"Am3sconnected device：%@",[info userInfo]);
    NSString *connectSeriaNub=[[info userInfo]objectForKey:@"SerialNumber"];
    NSString *connectID=[[info userInfo]objectForKey:@"ID"];
    //remove device from discoverDevices
    for (NSDictionary *discoverDevice in AM3SdiscoverDevices) {
        NSString *serialNub=[[AM3SdiscoverDevices objectAtIndex:0]objectForKey:@"SerialNumber"];
        NSString *ID=[[AM3SdiscoverDevices objectAtIndex:0]objectForKey:@"ID"];
        if (serialNub!=nil&& [serialNub isEqualToString:connectSeriaNub]) {
            [AM3SdiscoverDevices removeObject:discoverDevice];
            break;
        } else if(ID!=nil&& [ID isEqualToString:connectID]){
            [AM3SdiscoverDevices removeObject:discoverDevice];
            break;
        }
    }
    
    if(am3sArray.count>0)
    {
        AM3S *am3sInstance = [am3sArray objectAtIndex:0];
        HealthUser *myUser = [[HealthUser alloc]init];
        
        myUser.clientID = SDKKey;
        myUser.clientSecret = SDKSecret;
        myUser.userID = YourUserName;
        
        [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandGetUpdateVersionWithDeviceUUID:am3sInstance.currentUUID DisposeUpdateVersionResult:^(NSDictionary *updateVersionDic) {
            
            NSLog(@"updateVersionDic:%@",updateVersionDic);
            
            [[SDKUpdateDevice shareSDKUpdateDeviceInstance] commandStartUpdateWithDeviceUUID:am3sInstance.currentUUID DownloadFirmwareStart:^{
                
                NSLog(@"StartUpdate");
                
                
            } DisposeDownloadFirmwareFinish:^{
                
                NSLog(@"FinishUpdate");
                
            } DisposeUpdateProgress:^(NSNumber *progress) {
                
                NSLog(@"progress%@",progress);
                
            } DisposeUpdateResult:^(NSNumber *updateResult) {
                
                NSLog(@"updateResult%@",updateResult);
                
            } TransferSuccess:^(NSNumber *transferSuccess) {
                
                NSLog(@"transferSuccess%@",transferSuccess);
                
            } DisposeErrorBlock:^(UpdateDeviceError errorID) {
                
                NSLog(@"UpdateDeviceError%u",errorID);
            }];
            
            
            
        } DisposeErrorBlock:^(UpdateDeviceError errorID) {
            
        }];
    }
    
    
    
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}




@end
