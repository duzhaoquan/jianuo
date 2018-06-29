//
//  MineModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/27.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineModel : NSObject
/*member_name职员名称、member_sex性别、area_name所属地区、member_id_number身份证号码、 member_phone手机、member_education学历
 客户部分：customer_name客户名称、area_name所属地区、equipment_name所属设备、customer_contacts联系人、 customer_contacts_phone联系人电话、customer_contacts_mail邮箱
 */

@property (nonatomic,strong)NSString *member_name;

@property (nonatomic,strong)NSString *member_sex;
 
@property (nonatomic,strong)NSString *area_name;
 
@property (nonatomic,strong)NSString *member_id_number;
 
@property (nonatomic,strong)NSString *member_phone;
 
@property (nonatomic,strong)NSString *member_education;
 
//客户
@property (nonatomic,strong)NSString *customer_name;
 
@property (nonatomic,strong)NSString *customer_contacts_mail;

@property (nonatomic,strong)NSString *equipment_name;
 
@property (nonatomic,strong)NSString *customer_contacts;
 
@property (nonatomic,strong)NSString *customer_contacts_phone;


@end
