//
//  AssigningTaskViewController.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/17.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskReceiveViewController.h"
@interface AssigningTaskViewController : UIViewController

@property (nonatomic,strong)TaskReceiveViewController *taskReceiveViewController;
//任务id
@property (nonatomic,strong)NSString *task_id;
//任务订单
@property (nonatomic,strong)NSString *task_order;


@end
