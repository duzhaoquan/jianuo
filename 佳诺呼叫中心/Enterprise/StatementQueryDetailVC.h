//
//  StatementQueryDetailVC.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
@interface StatementQueryDetailVC : UIViewController
@property (nonatomic,strong)NSString *taskid;
@property (nonatomic,strong)TaskModel *model;
@end
