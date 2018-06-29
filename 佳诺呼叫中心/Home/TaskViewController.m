//
//  TaskViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskListTableViewCell.h"

@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TaskViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务";
    [self setupTableView];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[TaskListTableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_tableView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = [NSString stringWithFormat:@"任务%ld",indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < 5){
        return 60;
    }
    return 0.00000001;
}

@end
