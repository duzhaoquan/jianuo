//
//  TextFieldTableViewCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/28.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "TextFieldTableViewCell.h"
#import "NSString+HFExtension.h"


@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _firstLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenwidth-20, 40)];
        _firstLable.numberOfLines = 0;
        [self.contentView addSubview:_firstLable];
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_firstLable.frame), 20, kScreenwidth - (CGRectGetWidth(_firstLable.frame)+10), 40)];
        _textFieldCellType = TextFieldCellTypeText;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
    }
    return self;
}

//设置前面的文字后重新布局
-(void)setFirstLableText:(NSString *)firstLableText{
    _firstLableText = firstLableText;
    _firstLable.text = firstLableText;
    CGSize size = [firstLableText sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    if (size.height < 30) {
        _firstLable.frame = CGRectMake(10, 0, size.width+10, 40);
        _textField.frame = CGRectMake(CGRectGetMaxX(_firstLable.frame), 0, kScreenwidth - (CGRectGetWidth(_firstLable.frame)+10), 40);
        
    }else{
        _firstLable.frame = CGRectMake(10, 0, kScreenwidth - 20, size.height + 10);
        _textField.frame = CGRectMake(10, CGRectGetMaxY(_firstLable.frame), kScreenwidth - 20, 40);
        _textField.placeholder = @"请填写...";
        
    }
    
}

-(void)setTextFieldCellType:(TextFieldCellType)textFieldCellType{
    _textFieldCellType = textFieldCellType;
    if (textFieldCellType == TextFieldCellTypeDatePiker) {
        [self setdatepicker];
    }else{
        _textField.inputView = nil;
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_textFieldCellType == TextFieldCellTypeDatePiker) {
        if ([textField.text isEqualToString:@""]) {
            [self dateChanged];
        }
    }
    return YES;
}
//textField代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (_textFieldCellType == TextFieldCellTypeText) {
        [_delegate cellTextEndEdit:textField.text IndexPath:_indexPath];
    }else{//如果时间控件则返回时间戳字符串
        NSString *timeStr = [NSString stringWithFormat:@"%lf",_datePicker.date.timeIntervalSince1970];
        [_delegate cellTextEndEdit:timeStr IndexPath:_indexPath];
    }
}

#pragma mark - 时间选择器
-(void)setdatepicker{
    UIDatePicker*datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    datePicker.locale = locale;
    
    _textField.inputView = datePicker;
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged ];
    _datePicker = datePicker;
}


-(void)dateChanged{  
    UIDatePicker *control = _datePicker;  
    NSDate *date = control.date;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if (control.datePickerMode == UIDatePickerModeDate) {
        [formatter setDateFormat:@"yyyy年MM月dd日"];
    }else if(control.datePickerMode == UIDatePickerModeTime){
        [formatter setDateFormat:@"HH时mm分"];
    }else{
        [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    }
    
    NSString *confromTimespStr = [formatter stringFromDate:date];
    /*添加你自己响应代码*/  
    _textField.text = confromTimespStr;
}

//将表情过滤掉
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([NSString stringContainsEmoji:string]){
        return NO;
    }
    return YES;
}


@end
