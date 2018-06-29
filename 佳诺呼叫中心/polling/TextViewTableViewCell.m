//
//  TextViewTableViewCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/28.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "TextViewTableViewCell.h"
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000



@implementation TextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _firstLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenwidth, 20)];
        [self.contentView addSubview:_firstLable];
        _textView = [[XHMessageTextView alloc]initWithFrame:CGRectMake(10, 25, kScreenwidth -20, 60)];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor orangeColor].CGColor;
        _textView.layer.cornerRadius = 5;
        _textView.placeHolder = @"请填写内容...";
        [self.contentView addSubview:_textView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];

    _textView.frame = CGRectMake(10,25,self.frame.size.width -20,self.frame.size.height - 30 );
}

//编写结束时把结果传出去
-(void)textViewDidEndEditing:(UITextView *)textView{
    [_delegate cellTextEndEdit:textView.text IndexPath:_indexPath];
}

//将表情替换掉
- (void)textViewDidChange:(UITextView *)textView
{
    if ([NSString stringContainsEmoji:textView.text]){
        if (textView.text.length >= 2) {
            textView.text = [textView.text substringToIndex:textView.text.length -2];
        }else{
            textView.text = @"";
        }
       
    }
    
}

@end
