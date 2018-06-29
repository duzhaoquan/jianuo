//
//  DropDown.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/7.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDown:UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@property (nonatomic,assign)CGFloat tabheight;
@property (nonatomic,assign)CGFloat frameHeight;
@property (nonatomic,strong) UITableView *tv;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,retain) NSArray *tableArray;

@property (strong, nonatomic) NSDictionary *pickerDic;//获取文件里的字典

@property (strong, nonatomic) NSArray *provinceArray;//省、市

@property (nonatomic,retain) UITextField *textField;

@property (assign, nonatomic) BOOL showList;
@property (nonatomic,assign) CGRect beginFram;

-(void)dontshowlist;

@end


