//
//  SmokeRepairViewController.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/13.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmokeRepairViewController : UIViewController


@property (nonatomic,copy)NSString *formName;

@property (nonatomic,strong)NSDictionary *headerData;
@property (nonatomic,strong)UIViewController *formChoseVC;

@end
