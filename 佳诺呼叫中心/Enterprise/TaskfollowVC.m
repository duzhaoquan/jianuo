//
//  TaskfollowVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/20.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskfollowVC.h"
#import "TaskDetailTableViewCell.h"
#import "TxetViewController.h"
#import "TaskFollowTableViewCell.h"
#import "StateModel.h"
#import "LoopView.h"
#import "UIBarButtonItem+Extension.h"
@interface TaskfollowVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *stateList;

@end

@implementation TaskfollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务跟踪表";
    
    
    
    if ([[USERDEFALUTS objectForKey:@"utype"] isEqualToString:@"1"]) {
        self.title = @"故障维修进度";
    }
    _stateList = [NSMutableArray array];
    [self setupTableView];
    [self getdata];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"back" selectedImage:@"back" target:self action:@selector(leftBtnDidClick)];

}
- (void)leftBtnDidClick{
    
        [self.navigationController popViewControllerAnimated:YES];
 
        [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)getdata{
    __weak TaskfollowVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //status_name任务状态名称、states任务状态值、task_remarks任务备注、task_order任务单号、update_time备注时间、img1图片1、img2图片2、img3图片3
    params[@"task_order"] = _model.task_order;

    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_task_remarks"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"listData"];
        for (NSDictionary *dic in list) {
            
            StateModel *model = [[StateModel alloc]init];
            [model setKeyValues:dic];
            [_stateList addObject:model];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[TaskFollowTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _stateList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskFollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    StateModel *model = _stateList[indexPath.row];
    if(indexPath.row == 0 ){
        model.first = YES;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.section;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000001;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 1)];
    view.backgroundColor = kUIColorFromRGB(0xe9e9e9);
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 40)];
//    lable.text = [NSString stringWithFormat:@"任务单号:%@",_model.task_order];
//    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StateModel *model = _stateList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@" 任务状态:%@\n 备注信息:%@",model.status_name,model.task_remarks];
    
    if (![ZQ_CommonTool isEmpty:model.uname]) {
        text = [NSString stringWithFormat:@"%@\n 负责人:%@\n 负责人电话:%@",text,model.uname,model.uphone];
    }
    
    if (![ZQ_CommonTool isEmpty:model.arrive_time]) {
        text = [NSString stringWithFormat:@"%@\n 预计到场时间:%@",text,model.arrive_time];
    }
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 80];
    if (model.task_img1 != nil && model.task_img1.length > 0) {
        return size.height + 120;
    }
    
    
    return size.height + 30;    
}



@end
