//
//  TxetViewController.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/17.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TxetViewController : UIViewController


@property (nonatomic,strong)NSString *text;

@property (nonatomic,assign)BOOL canEdite;
@property (nonatomic,copy)void(^backText)(NSString*textStr);

@end
