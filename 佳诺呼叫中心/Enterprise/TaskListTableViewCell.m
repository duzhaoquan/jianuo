//
//  TaskListTableViewCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskListTableViewCell.h"


@implementation TaskListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, kScreenwidth - 10, 80)];
        _stateRemarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(_messageLabel.frame), kScreenwidth - 10, 20)];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_stateRemarkLabel];
        
    }
    return self;
}

-(void)setModel:(TaskModel *)model{
    _model = model;
    
    NSString *text = [NSString stringWithFormat:@"客户名称: %@ \n设备类型: %@ \n故障类型: %@ \n上报时间: %@ ",model.customer_name,model.equipment_name,model.fault_name,model.dt];
    if (_cellType == 4 || _cellType == 5) {
        text = [NSString stringWithFormat:@"客户名称: %@ \n设备类型: %@ \n故障类型: %@ \n上报时间: %@ \n任务状态: %@",model.customer_name,model.equipment_name,model.fault_name,model.dt,model.status_name];
    }

    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    _messageLabel.numberOfLines = 0;
    _messageLabel.text = text;
    _messageLabel.frame = CGRectMake(10, 5, kScreenwidth - 20, size.height);
    NSString *remarks = [NSString stringWithFormat:@"状态备注: %@",model.remarks];
    _stateRemarkLabel.text = remarks;
    _stateRemarkLabel.numberOfLines = 0;
    _stateRemarkLabel.textColor = [UIColor redColor];
    CGSize remarkSize = [remarks sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    _stateRemarkLabel.frame = CGRectMake(10, CGRectGetMaxY(_messageLabel.frame), kScreenwidth - 20, remarkSize.height);
    
}

@end
