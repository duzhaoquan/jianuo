//
//  ProgressQueryViewController.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//


#import "TaskViewController.h"

@interface ProgressQueryViewController : UIViewController
@property (nonatomic,copy) void (^QueryBlock)(void);
@end
