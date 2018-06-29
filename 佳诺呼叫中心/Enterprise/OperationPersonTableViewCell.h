//
//  OperationPersonTableViewCell.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/14.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperationPersonModel.h"
@interface OperationPersonTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *messageLabel;

@property (nonatomic,strong)OperationPersonModel *model;

@end
