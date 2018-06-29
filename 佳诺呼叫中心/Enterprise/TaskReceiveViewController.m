//
//  TaskReceiveViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskReceiveViewController.h"
#import "TaskListTableViewCell.h"
#import "TastReceiveDetailViewController.h"
#import "MJRefresh.h"
#import "TaskModel.h"

@interface TaskReceiveViewController ()

@property (nonatomic,assign)BOOL isremo;
@property (nonatomic,assign)NSString *page;
@property (nonatomic, strong) UILabel *thereLabel;
@property (nonatomic,strong)NSMutableArray *taskList;

@end

@implementation TaskReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务接受";
    _taskList = [NSMutableArray array];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getdata];
}



-(void)getdata{
    __weak TaskReceiveViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"group_id"] = [USERDEFALUTS objectForKey:@"group_id" ];
    if ([[USERDEFALUTS objectForKey:@"group_id"] isEqualToString:@"13"]) {
        params[@"status"] = @"2";
    } 
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_failure_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"listData"];
        if (list.count == 0) {
            [_taskList removeAllObjects];
            self.tableView.tableHeaderView = self.thereLabel;
        }else{
            [_taskList removeAllObjects];
            for (NSDictionary *dic in list) {
                TaskModel *model = [[TaskModel alloc]init];
                [model setKeyValues:dic];
                [_taskList addObject:model];
            }
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}
- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"您没有要接收的任务";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
//配置奖品
- (void)configuration:(NSArray *)array
{
    if ([ZQ_CommonTool isEmptyArray:array]) {
        [self showHint:@"没有奖品" yOffset:50];
    } else {
        if (_isremo == YES) {
//            if ([_dataArr count] != 0) {
//                [_dataArr removeAllObjects];
//            }
        }
        //[_dataArr addObjectsFromArray:array];
        [self.tableView reloadData];
    }
}
#pragma mark - 添加刷新
- (void)setupRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
}

- (void)loadNewStatus
{
    self.isremo = YES;
    self.page = @"1";
    [self getdata];
    [self.tableView headerEndRefreshing];
}

- (void)loadMoreStatus
{
    self.isremo = NO;
    int i = [_page intValue];
    self.page = [NSString stringWithFormat:@"%d", i + 1];
    [self getdata];
    [self.tableView footerEndRefreshing];
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
    TastReceiveDetailViewController *taskreceiveDeail = [[TastReceiveDetailViewController alloc]init];
    TaskModel *model = _taskList[indexPath.row];
    taskreceiveDeail.model = model;
    taskreceiveDeail.taskReceiveViewController = self;
    
    [self.navigationController pushViewController:taskreceiveDeail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskModel *model = _taskList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"客户名称: %@ \n设备类型: %@ \n故障类型: %@ \n上报时间: %@",model.customer_name,model.equipment_name,model.fault_name,model.dt];
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    NSString *remarks = [NSString stringWithFormat:@"状态备注: %@",model.remarks];
    CGSize remarkSize = [remarks sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    CGFloat height = size.height + remarkSize.height + 10;
    NSLog(@"s = %f,r = %f,h = %f",size.height,remarkSize.height,height);
    return height;
}

@end
