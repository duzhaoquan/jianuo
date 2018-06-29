//
//  OperationPersonTableViewCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/14.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "OperationPersonTableViewCell.h"

@implementation OperationPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenwidth - 100,0,60, self.frame.size.height)];
        _messageLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_messageLabel];
        
    }
    return self;
}

-(void)setModel:(OperationPersonModel *)model{
    _model = model;
    
    _messageLabel.text = model.failure_status;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
