//
//  EquipListModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/20.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipListModel : NSObject

/*
 "brands_name" = "<null>";
 "equipment_name" = "\U94a9\U673a";
 "install_position" = "\U524d\U540e\U65b9";
 "install_time" = "";
 model = "";
 "unique_code" = R57ys23ki8;
 */
@property (nonatomic,strong)NSString *brands_name;
@property (nonatomic,strong)NSString *equipment_name;
@property (nonatomic,strong)NSString *install_position;
@property (nonatomic,strong)NSString *install_time;
@property (nonatomic,strong)NSString *model;
@property (nonatomic,strong)NSString *unique_code;

@end
