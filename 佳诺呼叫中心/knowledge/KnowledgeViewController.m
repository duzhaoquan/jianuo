//
//  KnowledgeViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/2.
//  Copyright © 2018年 jianuohb. All rights reserved.
//


#import "KnowledgeViewController.h"
#import "KnowledgeCellTableViewCell.h"
#import "DropDown.h"
#import "CustomerModel.h"
#import "Fault.h"
#import "EquipmentModel.h"
#import "KnowledgeModel.h"
#import "BrandModel.h"
#import "KnowledgeDetailVC.h"

@interface KnowledgeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *thereLabel;
@property (nonatomic,strong)NSMutableArray *knowledgeList;
@property (nonatomic,strong)NSMutableArray *customerList;
@property (nonatomic,strong)NSMutableArray *faultList;
@property (nonatomic,strong)NSMutableArray *equipList;
@property (nonatomic,strong)NSMutableArray *brandList;
@property (nonatomic,strong)UITextField *knowledgeTextField;
@property (nonatomic,strong)DropDown *customerDropDown;
@property (nonatomic,strong)DropDown *equipentDropDown;
@property (nonatomic,strong)DropDown *brandDropDown;
@property (nonatomic,strong)DropDown *typeDropDown;
@property (nonatomic,strong)NSString *customerId;
@property (nonatomic,strong)NSString *brandId;
@property (nonatomic,strong)NSString *faultId;

@end

@implementation KnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"知识库";
    _knowledgeList = [NSMutableArray array];
    _customerList = [NSMutableArray array];
    _faultList = [NSMutableArray array];
    _equipList = [NSMutableArray array];
    _brandList = [NSMutableArray array];
    //textField
    if (_knowledgeTextField == nil) {
        _knowledgeTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5,(kScreenwidth - 20)*2/3, 30)];
        _knowledgeTextField.borderStyle = UITextBorderStyleRoundedRect;
        
        _knowledgeTextField.placeholder =@"请输入检索关键字...";
        _knowledgeTextField.delegate = self; 
        _knowledgeTextField.returnKeyType = UIReturnKeyDone;
        
        //_customerNameTextField.inputView = _datePicker;
    }
    [self setUpTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectInfo:) name:@"customerDropDown" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectInfo:) name:@"equipentDropDown" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectInfo:) name:@"brandDropDown" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectInfo:) name:@"typeDropDown" object:nil];
    
    [self getdata];
    
    
}

-(void)selectInfo:(NSNotification*)not{
    NSDictionary *dictionary = not.userInfo;
    NSInteger index = [dictionary[@"index"] integerValue];
    if ([not.name isEqualToString:@"customerDropDown"]) {
        if (index == -1) {
            _customerId = @"";
        }else{
            CustomerModel *model = [_customerList objectAtIndex:index];
            _customerId = model.customer_id;
        }
        
    }else if([not.name isEqualToString:@"brandDropDown"]){
        if (index == -1) {
            _brandId = @"";
        }else{
            BrandModel *model = [_brandList objectAtIndex:index];
            _brandId = model.brands_id;
        }
        
    }else if([not.name isEqualToString:@"typeDropDown"]){
        if (index == -1) {
            _faultId = @"";
        }else{
            Fault *fault = [_faultList objectAtIndex:index];
            _faultId = fault.fault_id;
        }
        
    }
     
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setUpTableView{
    
    UIView *headerVIew =[[UIView alloc]initWithFrame: CGRectMake(0, 64, kScreenwidth, 155)];
    [self.view addSubview:headerVIew];
    
    _customerDropDown = [[DropDown alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(headerVIew.frame)+50,kScreenwidth, kScreenheight/2 - 50)];
    _customerDropDown.textField.placeholder = @"客户名称";
    _customerDropDown.name = @"customerDropDown";
    _customerDropDown.textField.frame = CGRectMake(10, 0, kScreenwidth-20,30);
    NSArray *arr = @[@"1000",@"2000",@"3000",@"4000",@"5000",@"10000",@"20000",@"30000"];
    _customerDropDown.tableArray = arr;

//    _equipentDropDown = [[DropDown alloc]initWithFrame:CGRectMake(kScreenwidth/2, CGRectGetMinY(headerVIew.frame)+ 50,kScreenwidth/2, kScreenheight/2 - 50)];
//    _equipentDropDown.textField.placeholder = @"设备名称";
//    _equipentDropDown.name = @"equipentDropDown";
//    _equipentDropDown.textField.frame = CGRectMake(10, 0, kScreenwidth/2-15,30);
//    NSArray *arr1 = @[@"你",@"我",@"ta",@"4000",@"5000",@"10000",@"20000",@"30000"];
//    _equipentDropDown.tableArray = arr1;
    
    _brandDropDown = [[DropDown alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(headerVIew.frame)+ 50 +35,kScreenwidth, kScreenheight/2 - 50)];
    _brandDropDown.textField.placeholder = @"品牌";
    _brandDropDown.name = @"brandDropDown";
    _brandDropDown.textField.frame = CGRectMake(10, 0, kScreenwidth-20,30);
    NSArray *arr2 = @[@"牛",@"样",@"马",@"4000",@"5000",@"10000",@"20000",@"30000"];
    _brandDropDown.tableArray = arr2;
    
    _typeDropDown = [[DropDown alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(headerVIew.frame)+ 50 +70,kScreenwidth, kScreenheight/2 - 50)];
    _typeDropDown.textField.placeholder = @"故障类型";
    _typeDropDown.name = @"typeDropDown";
    _typeDropDown.textField.frame = CGRectMake(10, 0, kScreenwidth-20,30);
    NSArray *arr3 = @[@"小明",@"黄忠",@"刘邦",@"4000",@"5000",@"10000",@"20000",@"30000"];
    _typeDropDown.tableArray = arr3;
    
    
    [self.view addSubview:_customerDropDown];
    [self.view addSubview:_equipentDropDown];
    [self.view addSubview:_brandDropDown];
    [self.view addSubview:_typeDropDown];
    
    _knowledgeTextField.frame = CGRectMake(10, 5,(kScreenwidth - 20)*2/3,40);
    headerVIew.backgroundColor = [UIColor grayColor];
    [headerVIew addSubview:_knowledgeTextField];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(_knowledgeTextField.frame)+5, 5, (kScreenwidth - 20)/3, 40);
    [headerVIew addSubview:button];
    [button setTitle:@"查询" forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
    [button addTarget:self action:@selector(searchAcion:) forControlEvents:UIControlEventTouchUpInside];
    

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headerVIew.frame), kScreenwidth, kScreenheight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[KnowledgeCellTableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self.view addSubview:_tableView];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidelist)];  
    gestureRecognizer.numberOfTapsRequired = 1;    
    gestureRecognizer.cancelsTouchesInView = NO;  
    [self.tableView addGestureRecognizer:gestureRecognizer]; 
  
    
}
//查询
-(void)searchAcion:(UIButton*)butten{
    [self.knowledgeTextField resignFirstResponder];
    __weak KnowledgeViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"customer_id"] = _customerId;
    params[@"brands_id"] = _brandId;
    params[@"fault_id"] = _faultId;
    params[@"failure_description"] = _knowledgeTextField.text;
    NSLog(@"%@",params);
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/knowledge_search"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *list = responseObject[@"listData"];
            
            if (list.count == 0) {
                [_knowledgeList removeAllObjects];
                self.tableView.tableHeaderView = self.thereLabel;
            }else{
                [ self.thereLabel removeFromSuperview];
                [_knowledgeList removeAllObjects];
                [self.thereLabel removeFromSuperview];
                for (NSDictionary *dic in list) {
                    KnowledgeModel *model = [[KnowledgeModel alloc]init];
                    [model setKeyValues:dic];
                    [_knowledgeList addObject:model];
                }
                
            }
            
        }else{
            [weakSelf showHint:responseObject[@"msg"]];
            [_knowledgeList removeAllObjects];
            self.tableView.tableHeaderView = self.thereLabel;
        }
       [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

-(void)getdata{
    __weak KnowledgeViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/knowledge_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            NSArray *customerList = responseObject[@"customerData"];
            NSArray *faultList = responseObject[@"faultData"];
            NSArray *brandList = responseObject[@"brandsData"];
            if (customerList.count != 0) {
                for (NSDictionary *dic in customerList) {
                    CustomerModel *model = [[CustomerModel alloc]init];
                    [model setKeyValues:dic];
                    [_customerList addObject:model];
                    
                }
                _customerDropDown.tableArray = _customerList;
            }
            if (faultList.count != 0) {
                for (NSDictionary *dic in faultList) {
                    Fault *falut = [[Fault alloc]init];
                    [falut setKeyValues:dic];
                    [_faultList addObject:falut];
                }
                _typeDropDown.tableArray = _faultList;
            }
            
            if (brandList.count != 0) {
                for (NSDictionary *dic in brandList) {
                    BrandModel *model = [[BrandModel alloc]init];
                    [model setKeyValues:dic];
                    [_brandList addObject:model];
                }
                _brandDropDown.tableArray = _brandList;
            }
        }else{
            [weakSelf showHint:responseObject[@"mgs"]];
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"没有符合条件记录";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
#pragma mark- tableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    KnowledgeModel *model = [_knowledgeList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.failure_description;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _knowledgeList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KnowledgeDetailVC *knowDetail = [[KnowledgeDetailVC alloc]init];
    KnowledgeModel *model = [_knowledgeList objectAtIndex:indexPath.row];
    knowDetail.model = model;

    knowDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:knowDetail animated:YES];
}

-(void)hidelist{
    [_customerDropDown dontshowlist];
    [_equipentDropDown dontshowlist];
    [_brandDropDown dontshowlist];
    [_typeDropDown dontshowlist];
    
}
@end
