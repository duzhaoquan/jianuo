//
//  ChoseTableView.h
//  WMS_APP_IOS
//
//  Created by jp123 on 16/8/5.
//  Copyright © 2016年 jp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseTableViewDelegate


-(void)choseTableViewsureButtonclick;


@end


@interface ChoseTableView : UITableView



- (instancetype)initWithFrame:(CGRect)frame ItemName:(NSString *)itemName DataArray:(NSArray*)dataArray canNotMulSelected:(BOOL)canNotMulSelected;

- (instancetype)initWithFrame:(CGRect)frame ItemName:(NSString *)itemName DataArray:(NSArray*)dataArray;

//选择结果字符串数组
@property (nonatomic,strong)NSMutableArray *selectedValues;

//是否全选
@property (nonatomic,assign) BOOL isAllSelected;

//数据源字符串数组
@property (nonatomic,strong) NSArray *dataArr;

//项目名称
@property (nonatomic,strong) NSString *itemName;

//是否可以多选(yes为不可以多选)
@property (nonatomic,assign) BOOL canNotMulSelected;

//选中的单元格索引
@property (nonatomic,assign) NSInteger selectedIndex;

@property (nonatomic,strong) NSMutableArray *models;


@property(strong,nonatomic)UIWindow *window;


@property (nonatomic, weak, nullable) id <ChoseTableViewDelegate> choseDelegate;

@end



