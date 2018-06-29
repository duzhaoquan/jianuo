//
//  TaskFollowTableViewCell.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/20.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskFollowTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+ViewController.h"
#import "WXPhotoBrowser.h"
@interface TaskFollowTableViewCell ()<PhotoBrowerDelegate>{
    
}

@end

@implementation TaskFollowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, kScreenwidth - 100, 70)];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 50, 40)];
        _timeLabel.numberOfLines= 0;
        
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_timeLabel];
        
        _messageLabel.userInteractionEnabled = YES;

    }
    return self;
}
/*states;
 states_name;
 task_remarks;
 update_time;
 
 task_img1;
 task_img2;
 task_img3;*/
-(void)setModel:(StateModel *)model{
    _model = model;
    
    NSString *text = [NSString stringWithFormat:@" 任务状态:%@\n 备注信息:%@",model.status_name,model.task_remarks];
    if (![ZQ_CommonTool isEmpty:model.uname]) {
        text = [NSString stringWithFormat:@"%@\n 负责人:%@ \n 负责人电话:%@",text,model.uname,model.uphone];
    }
    if (![ZQ_CommonTool isEmpty:model.arrive_time]) {
        text = [NSString stringWithFormat:@"%@\n 预计到场时间:%@",text,model.arrive_time];
    }
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 100];
    
    _timeLabel.text = model.update_time;
    _messageLabel.numberOfLines = 0;
    _messageLabel.text = text;
    _messageLabel.frame = CGRectMake(80, 0, kScreenwidth - 80, size.height + 10);
    _iamgeArray = [NSMutableArray array];
    
    [self validPhoneNumLabel:_messageLabel labelStr:text];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(70, 0, 1, size.height + 30)];
    if(_model.first == YES){
        view.frame = CGRectMake(70, 10, 1, size.height + 30);
    }
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:141/255.0 blue:16/255.0 alpha:1].CGColor;
    [self addSubview:view];
    _cornView = [[UIView alloc]initWithFrame:CGRectMake(65, 10, 11, 11)];
    _cornView.layer.cornerRadius = 5.5;
    _cornView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:2/255.0 alpha:1].CGColor;
    [self addSubview:_cornView];
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (model.task_img1 != nil && model.task_img1.length > 0) {
        
        [_iamgeArray addObject:model.task_img1];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(80, size.height + 15, 90, 90)];
        imageView1.userInteractionEnabled = YES;
        imageView1.tag = 900;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView1 addGestureRecognizer:tap];

        view.frame = CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame), 1, CGRectGetHeight(view.frame)+ 90);
        [imageView1 sd_setImageWithURL:[NSURL URLWithString: model.task_img1] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        [self.contentView addSubview:imageView1];
    }
    if (model.task_img2 != nil && model.task_img2.length > 0) {
        [_iamgeArray addObject:model.task_img2];
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(180, size.height + 15, 90, 90)];
        imageView2.userInteractionEnabled = YES;
        imageView2.tag = 901;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView2 addGestureRecognizer:tap];
        [self.contentView addSubview:imageView2];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString: model.task_img2] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        
    }
    if (model.task_img3 != nil && model.task_img3.length > 0) {
        [_iamgeArray addObject:model.task_img3];
        UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(280, size.height + 15, 90, 90)];
        imageView3.userInteractionEnabled = YES;
        imageView3.tag = 902;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView3 addGestureRecognizer:tap];
        [self.contentView addSubview:imageView3];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString: model.task_img3] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }

    
}

-(void)tapAction:(UITapGestureRecognizer*)tap{
      
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:tap.view.tag -900 delegate:self];
        
}

- (void)layoutSubviews{
    
    
}



#pragma mark-<识手机号>  
- (void)validPhoneNumLabel:(UILabel *)label labelStr:(NSString *)labelStr{   
    //获取字符串中的电话号码  
    NSString *regulaStr = @"((\\(\\d{2,3}\\))|(\\d{3}\\-))?(1[3458]\\d{9})";  
    NSRange stringRange = NSMakeRange(0, labelStr.length);  
    //正则匹配  
    NSError *error;  
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];  
    if (!error && regexps != nil) {  
        [regexps enumerateMatchesInString:labelStr options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {  
            
            //可能为电话号码的字符串及其所在位置  
            //           NSString *actionString = [NSString stringWithFormat:@"%@",[_contentStr substringWithRange:result.range]];  
            NSRange phoneRange = result.range;  
            
            //            NSLog(@"%@-----%@", actionString, NSStringFromRange(phoneRange));  
            
            //设置文本中的电话号码显示为蓝色  
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:labelStr];  
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:phoneRange];  
            label.attributedText = str;  
            label.userInteractionEnabled = YES;
            //点击拨打电话  
            UIControl *phoneControl = [label viewWithTag:1234];  
            if (phoneControl == nil) {  
                UIControl *phoneControl = [[UIControl alloc] initWithFrame:[self boundingRectForCharacterRange:phoneRange andContentStr:labelStr]]; 
                phoneControl.tag = 1234;  
                [phoneControl addTarget:self action:@selector(phoneLink) forControlEvents:UIControlEventTouchUpInside];  
                [label addSubview:phoneControl];  
            }            
        }];  
    }  
}  

#pragma mark-<获取电话号码的坐标>  
- (CGRect)boundingRectForCharacterRange:(NSRange)range andContentStr:(NSString *)contentStr  
{  
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];  
    NSDictionary *attrs =@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]};  
    [attributeString setAttributes:attrs range:NSMakeRange(0, contentStr.length)];  
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributeString];  
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];  
    [textStorage addLayoutManager:layoutManager];  
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self.messageLabel bounds].size];  
    textContainer.lineFragmentPadding = 0;  
    [layoutManager addTextContainer:textContainer];  
    
    NSRange glyphRange;  
    
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];  
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];  
    CGFloat yOfset =  rect.origin.y;  
    rect.origin.y = yOfset + 4;  
    
    return rect;  
}  
#pragma mark-点击拨打电话  
- (void)phoneLink{  
    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",_model.uphone];  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]]; 
    
}  

#pragma mark - photoBrower delegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
  
    return _iamgeArray.count;
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    WXPhoto *photo = [[WXPhoto alloc]init];
    photo.srcImageView = [self.contentView viewWithTag:900+index];
    photo.url = [NSURL URLWithString:_iamgeArray[index]];
    
    return photo;
}

@end
