//
//  FormHeaderVC.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/27.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "BaseViewController.h"
#import "EquipmentModel.h"
#import "PollingTaskModel.h"
#import "FormModel.h"
@interface FormHeaderVC : BaseViewController

@property(nonatomic,strong)EquipmentModel *equipModel;
@property (nonatomic,strong)PollingTaskModel *taskModel;

@property (nonatomic,strong)UIViewController *formChoseVC;
@property (nonatomic,strong)FormModel *formModel;

@end
