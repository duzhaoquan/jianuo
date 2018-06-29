//
//  OperationPersonModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/18.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationPersonModel : NSObject

@property (nonatomic,strong)NSString *member_name;
@property (nonatomic,strong)NSString *member_id;
@property (nonatomic,strong)NSString *failure_status;
@property (nonatomic,assign)BOOL selected;

@end
