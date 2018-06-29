//
//  DZQTabbarControl.m
//  WXMovie
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "DZQTabbarButton.h"


@implementation DZQTabbarButton

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withLabelText:(NSString *)textName{
    self = [super initWithFrame:frame];
    if(self != nil){
        
        //添加标签
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,5,self.frame.size.width*0.7 ,self.frame.size.height - 10)];
        label.text = textName;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:17];
        [self addSubview:label];
        //添加图片
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        _imagetitle = imageName;
        imageView.tag = 1111;
        imageView.frame = CGRectMake(CGRectGetMaxX(label.frame) + 5,(self.frame.size.height - 20)/2,20,20);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
    }
    return self;
}

- (void)setImagetitle:(NSString *)imagetitle{
    _imagetitle = imagetitle;
    UIImageView *imageView = (UIImageView*)[self viewWithTag:1111];
    imageView.image = [UIImage imageNamed:imagetitle];
}

@end
