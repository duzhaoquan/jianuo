//
//  SegmentedTableViewCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/1.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "SegmentedTableViewCell.h"

@implementation SegmentedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _firstLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.frame.size.width-100, 40)];
        _firstLable.numberOfLines = 0;
        [self.contentView addSubview:_firstLable];
        _segControl = [[UISegmentedControl alloc]initWithItems:@[@"正常",@"异常"]];
        _segControl.selectedSegmentIndex = 0;               
        _segControl.frame=CGRectMake(self.frame.size.width-100, self.frame.size.height/2 - 15, 80, 30);
        //NSLog(@"self.frame.size.width:%f,self.frame.size.hieght:%f",self.frame.size.width,self.frame.size.height);
        [self.contentView addSubview:_segControl];
        [_segControl addTarget:self action:@selector(segAction:)  forControlEvents:UIControlEventValueChanged];
        
        
    }
    return self;
}

-(void)segAction:(UISegmentedControl*)control{
    if (control.selectedSegmentIndex == 0) {
        [self.delegate cellTextEndEdit:@"正常" IndexPath:_indexPath];
    }else{
        [self.delegate cellTextEndEdit:@"异常" IndexPath:_indexPath];
    }
}
//设置前面的文字后重新布局
-(void)setFirstLableText:(NSString *)firstLableText{
    _firstLableText = firstLableText;
    _firstLable.text = firstLableText;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    CGSize size = [_firstLableText sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:self.frame.size.width - 100];
    
    _firstLable.frame = CGRectMake(10, 0, self.frame.size.width-105, self.frame.size.height);
    _segControl.frame = CGRectMake(self.frame.size.width-95, self.frame.size.height/2 - 15, 80, 30);
}
@end
