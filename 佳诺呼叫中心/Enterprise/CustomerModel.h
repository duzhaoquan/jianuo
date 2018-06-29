//
//  CustomerModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/14.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject


/*
 （customer_type_name客户类型、area_name所属区域、equipment_name所属设备、contract_time 合同时间、contract_period合同期限、comparative_cost对比费用、accessory_cost承担配件费用、reagent_gas试剂标气、 maintenance_time_limit维修时效、emission_standard排放标准、customer_contacts联系人、customer_contacts_phone联系人 电话、customer_contacts_mail邮箱、customer_contacts_address通讯地址、customer_contacts2第二联系人、 customer_contacts2_phone第二联系人电话、customer_remarks备注）
 
 */

//巡检添加
@property (nonatomic,strong)NSString *customer_id;
//
@property (nonatomic,strong)NSString *customer_name;
@property (nonatomic,strong)NSString *customer_type_name;
//
@property (nonatomic,strong)NSString *area_name;
//
@property (nonatomic,strong)NSString *equipment_name;
//
@property (nonatomic,strong)NSString *contract_time;
//
@property (nonatomic,strong)NSString *contract_period;
//
@property (nonatomic,strong)NSString *comparative_cost;
//
@property (nonatomic,strong)NSString *accessory_cost;
//
@property (nonatomic,strong)NSString *reagent_gas;
//
@property (nonatomic,strong)NSString *maintenance_time_limit;
//
@property (nonatomic,strong)NSString *emission_standard;
//
@property (nonatomic,strong)NSString *customer_contacts;
//
@property (nonatomic,strong)NSString *customer_contacts_phone;
//
@property (nonatomic,strong)NSString *customer_contacts_mail;
//
@property (nonatomic,strong)NSString *customer_contacts_address;
//
@property (nonatomic,strong)NSString *customer_contacts2;
//
@property (nonatomic,strong)NSString *customer_contacts2_phone;
//
@property (nonatomic,strong)NSString *customer_remarks;


@end
