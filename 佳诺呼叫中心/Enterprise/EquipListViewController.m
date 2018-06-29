//
//  EquipListViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/20.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "EquipListViewController.h"
#import "EquipListTableViewCell.h"
#import "EquipListModel.h"
@interface EquipListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UILabel *thereLabel;
@property (nonatomic,strong)NSMutableArray *equipList;

@end

@implementation EquipListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备信息";
    _equipList = [NSMutableArray array];
    [self setuptableview];
    [self getdata];
}

-(void)setuptableview{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.estimatedSectionFooterHeight = 0;
    [_tableview registerClass:[EquipListTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableview];
}

- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"您没有设备";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
-(void)getdata{
    __weak EquipListViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"customer_id"] = _customer_id;
    
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"/index.php/api/api/get_equipment_detail"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"uniqid_info"];
        if (list.count == 0) {
            
            self.tableview.tableHeaderView = self.thereLabel;
        }else{
            
            for (NSDictionary *dic in list) {
                EquipListModel *model = [[EquipListModel alloc]init];
                [model setKeyValues:dic];
                [_equipList addObject:model];
            }
            [self.tableview reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _equipList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EquipListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    EquipListModel *model = _equipList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"设备类型: %@ \n型        号: %@ \n品        牌: %@ \n唯  一  码: %@ \n安装位置: %@ \n安装时间: %@",model.equipment_name,model.model,model.brands_name,model.unique_code,model.install_position,model.install_time];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}




@end
