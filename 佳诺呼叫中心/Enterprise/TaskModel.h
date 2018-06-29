//
//  TaskModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/18.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

/*
 failure_order故障任务单号、customer_code客户编码、customer_name客户名称、customer_contacts联系人、customer_contacts_phone联系电话、customer_contacts_address通讯地址、equipment_name设备信息、fault_name故障类型名称、failure_description故障描述、remarks备注、status状态、status_name状态名称、dt提交时间、update更新时间。
 */


//故障类型名称
@property (nonatomic,strong)NSString *fault_name;
//故障描述
@property (nonatomic,strong)NSString *failure_description;
//设备信息
@property (nonatomic,strong)NSString *equipment_name;
//提交时间
@property (nonatomic,strong)NSString *dt;
//故障任务单号
@property (nonatomic,strong)NSString *failure_order;
//任务id
@property (nonatomic,strong)NSString *task_id;
//任务单号
@property (nonatomic,strong)NSString *task_order;

//客户名称
@property (nonatomic,strong)NSString *customer_id;
@property (nonatomic,strong)NSString *customer_name;
//客户编码
@property (nonatomic,strong)NSString *customer_code;
//联系人
@property (nonatomic,strong)NSString *customer_contacts;
//通讯地址
@property (nonatomic,strong)NSString *customer_contacts_address;
//联系电话
@property (nonatomic,strong)NSString *customer_contacts_phone;
@property (nonatomic,strong)NSString *customer_contacts2_phone;

//设备唯一码
@property (nonatomic,strong)NSArray *equipment_uniqid_all;

@property (nonatomic,strong)NSString *equipment_uniqid;
//备注
@property (nonatomic,strong)NSString *remarks;

//状态
@property (nonatomic,strong)NSString *status;
//状态名称
@property (nonatomic,strong)NSString *status_name;

//更新时间
@property (nonatomic,strong)NSString *update;
/*
 */

@end
