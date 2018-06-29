//
//  StateModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/20.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StateModel : NSObject

/*
 states = 3;
 "status_name" = "\U63a5\U53d7\U4efb\U52a1";
 "task_img1" = "<null>";
 "task_img2" = "<null>";
 "task_img3" = "<null>";
 "task_order" = 002;
 "task_remarks" = "\U5230\U8fbe\U73b0\U573a";
 "update_time" = "2017-10-19 16:38";
 
 
 */

@property (nonatomic,copy)NSString *arrive_time;

@property (nonatomic,copy)NSString *uname;
@property (nonatomic,copy)NSString *uphone;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *status_name;
@property (nonatomic,copy)NSString *task_remarks;
@property (nonatomic,copy)NSString *update_time;
@property (nonatomic,copy)NSString *task_order;

@property (nonatomic,copy)NSString *task_img1;
@property (nonatomic,copy)NSString *task_img2;
@property (nonatomic,copy)NSString *task_img3;

@property (nonatomic,assign)BOOL first;

@end
