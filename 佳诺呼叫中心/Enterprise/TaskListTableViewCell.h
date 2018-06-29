//
//  TaskListTableViewCell.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@interface TaskListTableViewCell : UITableViewCell
@property (nonatomic,strong)TaskModel *model;

@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *stateRemarkLabel;
@property (nonatomic,assign)NSInteger cellType;//1人物接受 2到达现场 3任务核销 4报表查询 5客户进度查询

@end
