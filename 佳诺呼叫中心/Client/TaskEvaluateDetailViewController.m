//
//  TaskEvaluateDetailViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskEvaluateDetailViewController.h"
#import "LoopView.h"
#import "UIImageView+WebCache.h"
#import "DZQTabbarButton.h"
#import "TxetViewController.h"
#import "WXPhotoBrowser.h"
#import "StarView.h"
@interface TaskEvaluateDetailViewController ()<UITextFieldDelegate,PhotoBrowerDelegate>
@property (nonatomic,strong)LoopView  *loopView;
@property (nonatomic,assign)CGFloat safeArea;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)NSMutableArray *iamgeArray;
@property (nonatomic,strong)NSString *remarks;
@property (nonatomic,strong)UIView *completeView;
@property (nonatomic,strong)UILabel *label5;
@property (nonatomic,strong)UITextField *remarkTextField;
@property (nonatomic,strong)UIView *remarkView;
@property (nonatomic,strong)UIView *evaluatView;
@property (nonatomic,strong)NSString *evaluNum;
//服务满意度
@property (nonatomic,strong)StarView *degree_level;
//服务态度
@property (nonatomic,strong)StarView *attitude_level;
//到场时间
@property (nonatomic,strong)StarView *arrival_level;

@property (nonatomic,strong)NSMutableArray *iamgeViewArray;

@end

@implementation TaskEvaluateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务评价";
    self.view.backgroundColor = [UIColor whiteColor];
    _iamgeArray = [NSMutableArray array];
    _iamgeViewArray = [NSMutableArray array];
    _safeArea = 64;
    if (kScreenheight > 568) {
        _safeArea = 104;
    }
    if (kScreenheight == 812) {
        _safeArea += 24;
    }
    [self setupUI];
    [self getdata];
    //[self setloopView];
    
    //KVO观察键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupUI{
    //
    UIView *uidView = [[UIView alloc] initWithFrame:CGRectMake(10, 5+ _safeArea, self.view.frame.size.width - 20, 150)];
    uidView.backgroundColor = [UIColor whiteColor];
    uidView.layer.borderWidth = 1.0f;
    uidView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    //[[uidView layer] setCornerRadius:7.];
    uidView.userInteractionEnabled = YES;
    [[uidView layer] setMasksToBounds:YES];
    [self.view addSubview:uidView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, kScreenwidth - 20, 30)];
    label.text = [NSString stringWithFormat:@"客户名称: %@",_taskmodel.customer_name];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label];
    
    //
    UILabel *label4 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 30, kScreenwidth - 20, 30)];
    label4.text = [NSString stringWithFormat:@"设备类型: %@",_taskmodel.equipment_name];;
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = [UIColor blackColor];
    label4.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label4];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 2000, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xe2e2e2);
    [uidView addSubview:lineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 60, kScreenwidth - 20, 30)];
    label1.text = [NSString stringWithFormat:@"故障类型: %@",_taskmodel.fault_name];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 90, kScreenwidth - 20, 30)];
    label2.text = [NSString stringWithFormat:@"故障描述: %@",_taskmodel.failure_description];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label2];
    
    label2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(failure_description)];
    [label2 addGestureRecognizer:tap];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 120, kScreenwidth - 20, 30)];
    label3.text = [NSString stringWithFormat:@"上报时间: %@",_taskmodel.dt];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label3];
    
    
    _completeView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(uidView.frame), self.view.frame.size.width - 20, 180)];
    _completeView.backgroundColor = [UIColor whiteColor];
    _completeView.layer.borderWidth = 1.0f;
    _completeView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    //[[uidView layer] setCornerRadius:7.];
    [[_completeView layer] setMasksToBounds:YES];
    [self.view addSubview:_completeView];
    
    _label5 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, kScreenwidth - 20, 60)];
    _label5.text = [NSString stringWithFormat:@"维修人员完工备注:\n nihao"];
    _label5.textAlignment = NSTextAlignmentLeft;
    _label5.numberOfLines = 0;
    _label5.textColor = [UIColor blackColor];
    _label5.font = [UIFont systemFontOfSize:15];
    [_completeView addSubview:_label5];
    
    
    UILabel *label10 = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 100, 25)];
    label10.text = @"完工图片:";
    label10.font = [UIFont systemFontOfSize:17];
    [_completeView addSubview:label10];
    //kuang
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(2, 77, 322, 102)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    
    if (kScreenwidth < 375) {
        view.frame = CGRectMake(2, 77, 263, 82);
    }
    
    [_completeView addSubview:view];
    
    //评价
    _evaluatView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_completeView.frame), kScreenwidth - 20, 180)];
    _evaluatView.backgroundColor = [UIColor whiteColor];
//    _evaluatView.layer.borderWidth = 1.0f;
//    _evaluatView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    _evaluatView.userInteractionEnabled = YES;
    [self.view addSubview:_evaluatView];
    UILabel *label6 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, kScreenwidth - 20, 20)];
    label6.text = @"请选择满意度:";
    label6.textAlignment = NSTextAlignmentLeft;
    label6.textColor = [UIColor blackColor];
    label6.font = [UIFont systemFontOfSize:17];
    [_evaluatView addSubview:label6];
//    NSArray *evaluateArr = @[@"非常满意",@"满意",@"不满意"];
//    for (int i = 0; i < 3; i++) {
//        DZQTabbarButton *button = [[DZQTabbarButton alloc]initWithFrame:CGRectMake(0 + (kScreenwidth - 20)/3*i, 30, (kScreenwidth - 20)/3, 40) withImageName:@"选择框" withLabelText:evaluateArr[i]];
//        button.tag = 2000 + i;
//        [button addTarget:self action:@selector(evaluButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_evaluatView addSubview:button];
//    }
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 25, 80, 30)];
    label7.text = @"到场时间:";
    label7.textAlignment = NSTextAlignmentLeft;
    label7.textColor = [UIColor blackColor];
    label7.font = [UIFont systemFontOfSize:17];
    [_evaluatView addSubview:label7];
    
    _arrival_level = [[StarView alloc]initWithFrame:CGRectMake(100, 20, 200, 33)];
    _arrival_level.font_size = 35;
    _arrival_level.max_star = 5;
    _arrival_level.starNum = 3;
    _arrival_level.canSelected = YES;
    [_evaluatView addSubview:_arrival_level];
    
    UILabel *label8 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 55, 80, 30)];
    label8.text = @"服务态度:";
    label8.textAlignment = NSTextAlignmentLeft;
    label8.textColor = [UIColor blackColor];
    label8.font = [UIFont systemFontOfSize:17];
    [_evaluatView addSubview:label8];
    
    _attitude_level = [[StarView alloc]initWithFrame:CGRectMake(100, 50, 200, 33)];
    _attitude_level.font_size = 35;
    _attitude_level.max_star = 5;
    _attitude_level.canSelected = YES;
    [_evaluatView addSubview:_attitude_level];
    
    UILabel *label9 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 85, 100, 30)];
    label9.text = @"客户满意度:";
    label9.textAlignment = NSTextAlignmentLeft;
    label9.textColor = [UIColor blackColor];
    label9.font = [UIFont systemFontOfSize:17];
    [_evaluatView addSubview:label9];
    _degree_level = [[StarView alloc]initWithFrame:CGRectMake(100, 80, 200, 33)];
    _degree_level.font_size = 35;
    _degree_level.max_star = 5;
    _degree_level.canSelected = YES;
    [_evaluatView addSubview:_degree_level];
    
    _remarkView = [[UIView alloc] initWithFrame:CGRectMake(5, 120, self.view.frame.size.width - 30, 55)];
    _remarkView.backgroundColor = [UIColor whiteColor];
    _remarkView.layer.borderWidth = 1.0f;
    _remarkView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[_remarkView layer] setCornerRadius:7.];
    [[_remarkView layer] setMasksToBounds:YES];
    [_evaluatView addSubview:_remarkView];
    
    UILabel *remarklabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 55)];
    remarklabel.text = @"评价:";
    remarklabel.textAlignment = NSTextAlignmentLeft;
    remarklabel.textColor = [UIColor blackColor];
    remarklabel.font = [UIFont systemFontOfSize:15];
    [_remarkView addSubview:remarklabel];
    
    //
    self.remarkTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, CGRectGetWidth(_remarkView.frame) - 60, 55)];
    _remarkTextField.placeholder = @"请输评价内容";
    _remarkTextField.textAlignment = NSTextAlignmentLeft;
    _remarkTextField.borderStyle = UITextBorderStyleNone;
    _remarkTextField.font = [UIFont systemFontOfSize:15.f];
    _remarkTextField.delegate = self;
    //设置键盘的样式
    //_remarkTextField.keyboardType = UIKeyboardTypeDefault;
    _remarkTextField.returnKeyType = UIReturnKeyDone;
    [_remarkView addSubview:_remarkTextField];
    
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    surebutton.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [surebutton setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    surebutton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [surebutton setTitle:@"提交评价" forState:UIControlStateNormal];
    [surebutton setTintColor:[UIColor whiteColor]];
    [surebutton addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = surebutton;
    [self.view addSubview:surebutton];
}

-(void)failure_description{
    TxetViewController *textVC = [[TxetViewController alloc]init];
    textVC.text = _taskmodel.failure_description;
    textVC.title = @"故障描述";
    [self.navigationController pushViewController:textVC animated:YES];
}

- (void)evaluButtonAction:(DZQTabbarButton*)button{
    for (int i = 0; i < 3 ; i++) {
        DZQTabbarButton *btn = [_evaluatView viewWithTag:2000 +i];
        btn.imagetitle = @"选择框";
    }
    
    button.imagetitle = @"选择框选中";
    _evaluNum = [NSString stringWithFormat:@"%ld",3 - (button.tag - 2000)];
    
}
-(void)buttonDidClick{
    __weak TaskEvaluateDetailViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //uid客户id、task_id任务id、task_order故障任务订单号、utype职员/客户、remarks备注
    //customer_id客户id、order_num订单号、level评价级别（3好2中1差）、content评价内容、order_id订单id、utype客户/职员
    params[@"order_num"] = _taskmodel.task_order;
    params[@"customer_id"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"order_id"] = _taskmodel.task_id;
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"content"] = _remarkTextField.text;
    params[@"degree_level"] = [NSString stringWithFormat:@"%ld",_degree_level.show_star];
    params[@"attitude_level"] = [NSString stringWithFormat:@"%ld",_attitude_level.show_star];
    params[@"arrival_level"] = [NSString stringWithFormat:@"%ld",_arrival_level.show_star];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/customer_evaluation"];
    
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
    __weak TaskEvaluateDetailViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"task_order"] = _taskmodel.task_order;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_confirmation_info"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary *list = responseObject[@"listData"];
        
        _remarks = list[@"remarks"];
        NSString *img1 = list[@"img1"];
        if (![ZQ_CommonTool isEmpty:img1]) {
            [_iamgeArray addObject:img1];
        }
        NSString *img2 = list[@"img2"];
        if (![ZQ_CommonTool isEmpty:img2]) {
            [_iamgeArray addObject:img2];
        }
        NSString *img3 = list[@"img3"];
        if (![ZQ_CommonTool isEmpty:img3]) {
            [_iamgeArray addObject:img3];
        }
        [weakSelf configurationimg];
        [weakSelf getStarNum];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
    
   
}
-(void)getStarNum{
     __weak TaskEvaluateDetailViewController *weakSelf = self;
    NSString *URL1 = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_appraise_star"];
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    params1[@"order_no"] = _taskmodel.task_order;
    [manager POST:URL1 parameters:params1 progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSDictionary *response = responseObject;
        NSLog(@"responseObject = %@",responseObject);
        
        if([response[@"code"] integerValue] == 1){
            NSDictionary *star_info = response[@"star_info"];
            weakSelf.arrival_level.starNum = [star_info[@"star_info"] integerValue];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}
-(void)configurationimg{
    _label5.text = [NSString stringWithFormat:@"维修人员完工备注:%@",_remarks];
    for (int i = 0;i< _iamgeArray.count;i++) {
        NSString*img =  _iamgeArray[i];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(3 + i*110, 78, 100, 100)];
        if (kScreenwidth < 375) {
            imageView1.frame = CGRectMake(3+i*90, 78, 80, 80);
        }
        imageView1.userInteractionEnabled = YES;
        imageView1.tag = 1000+i;
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView1 addGestureRecognizer:tap];
        [_completeView addSubview:imageView1];
        
        [_iamgeViewArray addObject:imageView1];
    }
    
//    if (_iamgeArray.count > 0) {
//        _loopView.arr = _iamgeArray;
//    }
    
}
-(void)tapAction:(UITapGestureRecognizer*)tap{
//    if (_loopView.hidden == YES) {
//        _loopView.hidden = NO;
//
//    }else{
//        _loopView.hidden = YES;
//        
//    }
    
//    [(UIImageView*)tap.view sd_setImageWithURL:[NSURL URLWithString:_iamgeArray[tap.view.tag - 1000]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
//    
    [WXPhotoBrowser showImageInView:self.view.window selectImageIndex:tap.view.tag - 1000 delegate:self];
    
}

//- (void)setloopView{
//    if ( _loopView == nil) {
//        _loopView = [[LoopView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight)];
//        _loopView.tag = 666;
//        _loopView.hidden = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        [_loopView addGestureRecognizer:tap];
//        
//        [self.view addSubview:_loopView];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_remarkTextField resignFirstResponder];
    return YES;
}
#pragma mark - photoBrower delegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    
    return _iamgeViewArray.count;
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    WXPhoto *photo = [[WXPhoto alloc]init];
    
    photo.srcImageView = _iamgeViewArray[index];
    
    photo.url = [NSURL URLWithString:_iamgeArray[index]];
    
    return photo;
}

#pragma mark - 键盘输入事件处理
- (void)willShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    
    self.remarkView.transform = CGAffineTransformMakeTranslation(0, -keyboardH + kScreenheight - CGRectGetMaxY(_evaluatView.frame));
    
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
