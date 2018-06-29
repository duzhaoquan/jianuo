//
//  PollingTaskModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/7.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PollingTaskModel : NSObject


//客户名称
@property (nonatomic,copy)NSString *customer_id;

@property (nonatomic,copy)NSString *customer_name;
//人员
@property (nonatomic,copy)NSString *member_name;
//时间
@property (nonatomic,copy)NSString *addtime;
//订单号
@property (nonatomic,copy)NSString *order_sn;
//
@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *arrivetime;

@property (nonatomic,copy)NSString *finishtime;

@property (nonatomic,strong)NSString *customer_contacts_phone;
@property (nonatomic,strong)NSString *customer_contacts;

@end
