//
//  DZQTabbarControl.h
//  WXMovie
//
//  Created by mac on 16/4/18.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZQTabbarButton : UIControl


//初始化方法
- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName withLabelText:(NSString *)textName;


//图片名称
@property (nonatomic,copy) NSString *imagetitle;
//是否箭头朝下
@property (nonatomic,assign) BOOL isDown;



@end
