//
//  ABPMController.h
//  MedicaApp
//
//  Created by zhiwei jing on 9/21/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABPMController : NSObject{
    
    NSMutableArray *abpmArray;
}

+(ABPMController *)shareABPMController;

//获取当前所有ABPM实例
-(NSArray *)getAllCurrentABPMInstace;



@end
