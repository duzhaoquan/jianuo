//
//  MineViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/11.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "MineViewController.h"
#import "LoginNavigationVC.h"
#import "LoginViewController.h"
#import "TaskListTableViewCell.h"
#import "JPUSHService.h"
#import "MineModel.h"
#import "ChangePasswordViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *faultList;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)MineModel *model;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    _model = [[MineModel alloc]init];
    [self setuptableview];
    [self setupUI];
    //[self getdata];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ZQ_CommonTool isEmpty:_model.member_name]) {
        [self getdata];
    }
}
-(void)setuptableview{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.estimatedSectionFooterHeight = 0;
    _tableview.bounces = NO;
    if (kScreenheight > 568) {
        _tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 50)];
    }
    
    [_tableview registerClass:[TaskListTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableview];
}

-(void)getdata{
    __weak MineViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"group_id"] = [USERDEFALUTS objectForKey:@"group_id" ];
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/usercenter"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSDictionary *dic = responseObject[@"usercenter"];
        
        [_model setKeyValues:dic];
 
        [_tableview reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if ([[USERDEFALUTS objectForKey:@"utype"] isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"客户名称:%@",_model.customer_name];
        }else if(indexPath.section == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"所属地区:%@",_model.area_name];
        }else if (indexPath.section == 2){
            cell.textLabel.text = [NSString stringWithFormat:@"设备类型:%@",_model.equipment_name];
        }else if (indexPath.section == 3){
            cell.textLabel.text = [NSString stringWithFormat:@"联系人:%@",_model.customer_contacts];
        }else if (indexPath.section == 4){
            cell.textLabel.text = [NSString stringWithFormat:@"手机:%@",_model.customer_contacts_phone];
        }else if (indexPath.section == 5){
            cell.textLabel.text = [NSString stringWithFormat:@"邮箱:%@",_model.customer_contacts_mail];
        }
    }else{
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"员工姓名:%@",_model.member_name];
        }else if(indexPath.section == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"员工性别:%@",_model.member_sex];
        }else if (indexPath.section == 2){
            cell.textLabel.text = [NSString stringWithFormat:@"员工学历:%@",_model.member_education];
        }else if (indexPath.section == 3){
            cell.textLabel.text = [NSString stringWithFormat:@"所属地区:%@",_model.area_name];
        }else if (indexPath.section == 4){
            cell.textLabel.text = [NSString stringWithFormat:@"手机号:%@",_model.member_phone];
        }else if (indexPath.section == 5){
            cell.textLabel.text = [NSString stringWithFormat:@"证件号:%@",_model.member_id_number];
        }
    }
    
    if (indexPath.section == 6) {
        cell.textLabel.text = @"修改密码";
        //cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 5) {
        return 15;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if(section == 6){
        return 100;
    }else{
       return 0; 
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 6) {
        ChangePasswordViewController *changeVC = [[ChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
}
- (void)setupUI{
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    surebutton.frame = ZQ_RECT_CREATE(20, kScreenheight - 200, kScreenwidth - 40, 45);
    [surebutton setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    surebutton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    surebutton.layer.cornerRadius = 5;
    [surebutton setTitle:@"退出账号" forState:UIControlStateNormal];
    [surebutton setTintColor:[UIColor whiteColor]];
    [surebutton addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = surebutton;
    [self.view addSubview:surebutton];
}


-(void)buttonDidClick{
    //登录者userid
    [USERDEFALUTS setObject:@"0" forKey:@"uid"];
    [USERDEFALUTS setObject:@"0" forKey:@"user_id"];
    [USERDEFALUTS setObject:@"0" forKey:@"utype"];
    [USERDEFALUTS setObject:@"0" forKey:@"group_id"];
    [USERDEFALUTS setObject:@"0" forKey:@"area_id"];
    [USERDEFALUTS synchronize];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"deleteAlias/iResCode = %ld",iResCode);
    } seq:123];
    
    self.tabBarController.selectedIndex = 0;
    //[self.navigationController popToRootViewControllerAnimated:YES];
    LoginViewController *login = [[LoginViewController alloc]init];
    LoginNavigationVC *loginNavi = [[LoginNavigationVC alloc]initWithRootViewController:login];
    [UIApplication sharedApplication].delegate.window.rootViewController = loginNavi;
}

@end
