//
//  TaskFollowTableViewCell.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/20.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateModel.h"
#import "LoopView.h"
@interface TaskFollowTableViewCell : UITableViewCell
@property (nonatomic,strong)StateModel *model;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)LoopView *loopView;
@property (nonatomic,strong)NSMutableArray *iamgeArray;
@property (nonatomic,assign)CGFloat *hight;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIView *cornView;

@end
