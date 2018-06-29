//
//  CustomerInforTableViewCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/14.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "CustomerInforTableViewCell.h"

@implementation CustomerInforTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenwidth - 20, self.frame.size.height - 10)];
        [self.contentView addSubview:_messageLabel];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:17];
        //_messageLabel.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _messageLabel.frame = CGRectMake(10, 5, kScreenwidth - 20, self.frame.size.height - 10);
}


@end
