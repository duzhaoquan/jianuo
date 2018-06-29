//
//  MessageAndDetailCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/28.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "MessageAndDetailCell.h"

@implementation MessageAndDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenwidth - 100,self.frame.size.height/2 - 15,60, 30)];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,kScreenwidth - 110, self.frame.size.height)];
        _messageLabel.numberOfLines = 0;
        [_messageLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_detailLabel];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGSize textSize = [_messageLabel.text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 110];
    
    if ([keyPath isEqualToString:@"text"]||[keyPath isEqualToString:@"frame"]) {
        _messageLabel.frame = CGRectMake(10,(self.frame.size.height - textSize.height)/2,kScreenwidth - 105, textSize.height);
        _detailLabel.frame = CGRectMake(kScreenwidth - 90,self.frame.size.height/2 - 15,60, 30);
        
    } else{  
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];  
    } 
}
@end
