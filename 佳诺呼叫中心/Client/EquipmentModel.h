//
//  EquipmentModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/1.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipmentModel : NSObject

                                       
@property(nonatomic,copy)NSString *equipment_name;

@property(nonatomic,copy)NSString *install_position;
@property(nonatomic,copy)NSString *unique_code;

//设备型号
@property(nonatomic,copy)NSString *model;
//巡检添加
@property(nonatomic,copy)NSString *brands_name;//品牌
@property(nonatomic,copy)NSString *equipment_id;
@property(nonatomic,copy)NSString *type;
@property (nonatomic,assign)BOOL selected;
@property(nonatomic,copy)NSString *status;


@end
