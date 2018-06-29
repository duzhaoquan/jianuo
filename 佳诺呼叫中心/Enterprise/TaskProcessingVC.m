//
//  TaskProcessingVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskProcessingVC.h"
#import "TaskListTableViewCell.h"
#import "TaskModel.h"
#import "TaskProcessingDetailVC.h"

@interface TaskProcessingVC ()
@property (nonatomic,strong)NSMutableArray *taskList;
@property (nonatomic,strong)UILabel *thereLabel;
@end

@implementation TaskProcessingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"现场处理";

    _taskList = [NSMutableArray array];
    if ([[USERDEFALUTS objectForKey:@"group_id"] isEqualToString:@"12"]) {
        self.tableView.tableHeaderView = self.thereLabel;
    } else {
       [self getdata]; 
    }
    
}

-(void)getdata{
    __weak TaskProcessingVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"group_id"] = [USERDEFALUTS objectForKey:@"group_id" ];
    params[@"status"] = @"3";
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_failure_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"listData"];
        if (list.count == 0) {
            self.tableView.tableHeaderView = self.thereLabel;
        }else{
            for (NSDictionary *dic in list) {
                TaskModel *model = [[TaskModel alloc]init];
                [model setKeyValues:dic];
                [_taskList addObject:model];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}
- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"您没有要处理的任务";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}


#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _taskList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    TaskModel *model = _taskList[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TaskProcessingDetailVC *taskprocessingDeail = [[TaskProcessingDetailVC alloc]init];
    TaskModel *model = _taskList[indexPath.row];
    taskprocessingDeail.model = model;
    
    [self.navigationController pushViewController:taskprocessingDeail animated:YES];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskModel *model = _taskList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"客户名称: %@ \n设备类型: %@ \n故障类型: %@ \n上报时间: %@",model.customer_name,model.equipment_name,model.fault_name,model.dt];
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    NSString *remarks = [NSString stringWithFormat:@"状态备注: %@",model.remarks];
    CGSize remarkSize = [remarks sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    CGFloat height = size.height + remarkSize.height + 10;
    //NSLog(@"s = %f,r = %f,h = %f",size.height,remarkSize.height,height);
    return height;

}

@end
