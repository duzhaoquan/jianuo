//
//  KnowledgeModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/23.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowledgeModel : NSObject
@property(nonatomic,strong)NSString *know_id;
@property(nonatomic,strong)NSString *failure_description;

@property(nonatomic,strong)NSString *customer_name;
@property(nonatomic,strong)NSString *brands_name;
@property(nonatomic,strong)NSString *install_position;
@property(nonatomic,strong)NSString *fault_name;
@property(nonatomic,strong)NSString *solutions;
@property(nonatomic,strong)NSString *remarks;
@property(nonatomic,strong)NSString *dt;

@property(nonatomic,strong)NSString *img1;
@property(nonatomic,strong)NSString *img2;
@property(nonatomic,strong)NSString *img3;

@end
