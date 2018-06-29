//
//  HomeViewController.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/11.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

@property (nonatomic,assign)BOOL isClient;//是否是客户端

@property (nonatomic,strong) UILabel *redDot;

@property (nonatomic,copy) void (^QueryBlock)(void);


@end
