//
//  UserModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/17.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface UserModel : NSObject

@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *utype;
@property (nonatomic,strong)NSString *group_id;
@property (nonatomic,strong)NSString *area_id;
@end
