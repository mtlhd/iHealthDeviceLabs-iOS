//
//  KD723ViewController.h
//  testShareCommunication
//
//  Created by my on 14/10/13.
//  Copyright (c) 2013年 my. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KD723Controller : NSObject{
NSMutableArray *KD723DeviceArray;
}
+(KD723Controller *)shareKD723Controller;

-(NSArray *)getAllCurrentKD723Instace;
@end
