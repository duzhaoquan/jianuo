//
//  AssigningTaskViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/17.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "AssigningTaskViewController.h"
#import "TaskDetailTableViewCell.h"
#import "OperationPersonModel.h"
#import "OperationPersonTableViewCell.h"

@interface AssigningTaskViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)NSMutableArray *personList;
@property (nonatomic,strong)UILabel *thereLabel;
@property (nonatomic,strong)UITextField *remarkTextField;
@property (nonatomic,strong)NSString *member_id;


@property (nonatomic,strong)UIView *remarkView;

@end

@implementation AssigningTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务分配";

    _personList = [NSMutableArray array];
    [self setupTableView];
    [self setupbutton];
    [self getdata];
    
    //KVO观察键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[OperationPersonTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
}

-(void)setupbutton{
    
    //账号、密码
    _remarkView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenheight - 100, self.view.frame.size.width - 20, 55)];
    _remarkView.backgroundColor = [UIColor whiteColor];
    _remarkView.layer.borderWidth = 1.0f;
    _remarkView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[_remarkView layer] setCornerRadius:7.];
    [[_remarkView layer] setMasksToBounds:YES];
    [self.view addSubview:_remarkView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 55)];
    label.text = @"备注:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [_remarkView addSubview:label];
    
    
    //手机号Tex
    self.remarkTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, CGRectGetWidth(_remarkView.frame) - 60, 55)];
    _remarkTextField.placeholder = @"请输入备注信息";
    _remarkTextField.textAlignment = NSTextAlignmentLeft;
    _remarkTextField.borderStyle = UITextBorderStyleNone;
    _remarkTextField.font = [UIFont systemFontOfSize:15.f];
    _remarkTextField.delegate = self;
    //设置键盘的样式
    //_remarkTextField.keyboardType = UIKeyboardTypeDefault;
    _remarkTextField.returnKeyType = UIReturnKeyDone;
    [_remarkView addSubview:_remarkTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
  
    [button setTitle:@"确定分配任务" forState:UIControlStateNormal];
    
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = button;
    [self.view addSubview:button];
}


-(void)buttonDidClick{
    

    //uid主管id、member_id运维人员id、task_id任务id、task_order故障任务订单号、utype职员/客户

    __weak AssigningTaskViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"task_id"] = self.task_id;
    params[@"task_order"] = self.task_order;
    params[@"member_id"] = self.member_id;
    params[@"remarks"] = _remarkTextField.text;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/assignment_task"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        [weakSelf showHint:responseObject[@"msg"]];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
    
}

-(void)getdata{
    __weak AssigningTaskViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"area_id"] = [USERDEFALUTS objectForKey:@"area_id"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_area_users"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"listData"];
        if (list.count == 0) {
            self.tableView.tableHeaderView = self.thereLabel;
        }else{
            for (NSDictionary *dic in list) {
                OperationPersonModel *model = [[OperationPersonModel alloc]init];
                [model setKeyValues:dic];
                [_personList addObject:model];
            }
            OperationPersonModel *model = _personList[0];
            model.selected = YES;
            self.member_id = model.member_id;
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
        _thereLabel.text = @"没有人员可分配";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _personList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OperationPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OperationPersonModel *model = _personList[indexPath.row];
    cell.textLabel.text = model.member_name;
    cell.model = model;
    if (model.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i<_personList.count; i++) {
        OperationPersonModel *model = _personList[i];
        model.selected = NO;
        if (i == indexPath.row) {
            model.selected = YES;
            self.member_id = model.member_id;
        }
    }
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_remarkTextField resignFirstResponder];
    return YES;
}

#pragma mark - 键盘输入事件处理
- (void)willShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    self.remarkView.transform = CGAffineTransformMakeTranslation(0, -keyboardH + 45);
    
    [UIView commitAnimations];
    
}

-(void)hideShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.remarkView.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
} 


@end
