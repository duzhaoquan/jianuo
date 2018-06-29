//
//  PollingTaskDetailVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/7.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "PollingTaskDetailVC.h"
#import "PollingTaskDetailCell.h"
#import "EquipmentModel.h"


@interface PollingTaskDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *equipList;
@property (nonatomic,strong) UILabel *thereLabel;
@property (nonatomic,strong) UILabel *last_finishtime;
@property (nonatomic,strong) UILabel *timeLabel;
@end

@implementation PollingTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择设备";
    _equipList = [NSMutableArray array];
    [self setupTableView];
    [self getdata];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[PollingTaskDetailCell class] forCellReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_tableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [button setTitle:@"接受任务" forState:UIControlStateNormal];
    
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenheight - 100, kScreenwidth, 45)];
    _timeLabel.text = [NSString stringWithFormat:@"上次巡检时间:%@",_last_finishtime];
    _timeLabel.textColor = [UIColor redColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
     //kUIColorFromRGB(0xf1f1f1);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:17.f];
    
    [self.view addSubview:_timeLabel];
}
-(void)buttonDidClick{
    
    NSMutableArray *selectEquips = [NSMutableArray array];
    NSString *selectEquipString = @"";
    for (EquipmentModel *model in _equipList) {
        if (model.selected) {
            [selectEquips addObject:model];
            selectEquipString =   [NSString stringWithFormat:@"%@,%@",selectEquipString,model.equipment_id];
        }
    }
    
    
    if (selectEquips.count == 0) {
        [WCAlertView showAlertWithTitle:@"提示" message:@"未选择设备" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    } else {
        selectEquipString = [selectEquipString substringFromIndex:1];
        [self taskReceive:selectEquipString];
    }
}


-(void)taskReceive:(NSString*)equipIds{
    
    __weak PollingTaskDetailVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //uid运维人员id、task_id任务id、task_order故障任务订单号、utype职员/客户、remarks备注
    
    params[@"order_sn"] = self.order_sn;
    params[@"equipment_id"] = equipIds;
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/claim_task"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        //NSLog(@"responseObject = %@",responseObject);
        [weakSelf showHint:responseObject[@"msg"]];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}


-(void)getdata{
    __weak PollingTaskDetailVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"customer_id"] = self.customer_id;
    params[@"order_sn"] = self.order_sn;
    //http://192.168.12.230:90/index.php/api/Inspect/get_task_list
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/get_task_detail"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        if([responseObject[@"code"] integerValue] == 1){
            _last_finishtime = responseObject[@"last_finishtime"];
            _timeLabel.text = [NSString stringWithFormat:@"上次巡检时间:%@",_last_finishtime];
            NSArray *list = responseObject[@"listData"];
            if (list.count == 0) {
                [_equipList removeAllObjects];
                self.tableView.tableHeaderView = self.thereLabel;
            }else{
                [_equipList removeAllObjects];
                for (NSDictionary *dic in list) {
                    EquipmentModel *model = [[EquipmentModel alloc]init];
                    [model setKeyValues:dic];
                    [_equipList addObject:model];
                    
                }
                
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
        _thereLabel.text = @"您没有要选择的设备";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _equipList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PollingTaskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    EquipmentModel *model = (EquipmentModel *)[_equipList objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"设备品牌: %@ \n设备位置: %@",model.brands_name,model.install_position];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EquipmentModel *model = (EquipmentModel *)[_equipList objectAtIndex:indexPath.row];
    model.selected = !model.selected;
    [tableView reloadData];
}

@end
