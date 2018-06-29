//
//  AchieveSureDetailViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "AchieveSureDetailViewController.h"
#import "LoopView.h"
#import "UIImageView+WebCache.h"
#import "TxetViewController.h"
#import "WXPhotoBrowser.h"

@interface AchieveSureDetailViewController ()<UITextFieldDelegate,PhotoBrowerDelegate>
@property (nonatomic,strong)LoopView  *loopView;
@property (nonatomic,assign)CGFloat safeArea;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)NSMutableArray *iamgeArray;
@property (nonatomic,strong)NSString *remarks;
@property (nonatomic,strong)UIView *completeView;
@property (nonatomic,strong)UILabel *label5;
@property (nonatomic,strong)UITextField *remarkTextField;
@property (nonatomic,strong)UIView *remarkView;

@property (nonatomic,strong)NSMutableArray *iamgeViewArray;
@end

@implementation AchieveSureDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完工确认";
    self.view.backgroundColor = [UIColor whiteColor];
    _iamgeArray = [NSMutableArray array];
    _iamgeViewArray = [NSMutableArray array];
    _safeArea = 64;
    if (kScreenheight == 812) {
        _safeArea += 24;
    }
    [self setupUI];
    [self getdata];
    [self setloopView];
    
    //KVO观察键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)setupUI{
    //
    UIView *uidView = [[UIView alloc] initWithFrame:CGRectMake(10, 5+ _safeArea, self.view.frame.size.width - 20, 150)];
    uidView.backgroundColor = [UIColor whiteColor];
    uidView.layer.borderWidth = 1.0f;
    uidView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    //[[uidView layer] setCornerRadius:7.];
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
    
     _remarkView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenheight - 100, self.view.frame.size.width - 20, 55)];
    _remarkView.backgroundColor = [UIColor whiteColor];
    _remarkView.layer.borderWidth = 1.0f;
    _remarkView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[_remarkView layer] setCornerRadius:7.];
    [[_remarkView layer] setMasksToBounds:YES];
    [self.view addSubview:_remarkView];
    
    UILabel *remarklabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 55)];
    remarklabel.text = @"备注:";
    remarklabel.textAlignment = NSTextAlignmentLeft;
    remarklabel.textColor = [UIColor blackColor];
    remarklabel.font = [UIFont systemFontOfSize:15];
    [_remarkView addSubview:remarklabel];
    
    
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
    
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    surebutton.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [surebutton setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    surebutton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [surebutton setTitle:@"客户确认维修完成" forState:UIControlStateNormal];
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

-(void)buttonDidClick{
    __weak AchieveSureDetailViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //uid客户id、task_id任务id、task_order故障任务订单号、utype职员/客户、remarks备注
    params[@"task_order"] = _taskmodel.task_order;
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"task_id"] = _taskmodel.task_id;
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"remarks"] = _remarkTextField.text;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/customer_confirmation"];
    
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
    __weak AchieveSureDetailViewController *weakSelf = self;
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
        if (![ZQ_CommonTool isEmptyDictionary:list]) {
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
        imageView1.tag = 1000 + i;
        //imageView1.backgroundColor = [UIColor redColor];
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
//        
//    }else{
//        _loopView.hidden = YES;
//        
//  
    
//    [(UIImageView*)tap.view sd_setImageWithURL:[NSURL URLWithString:_iamgeArray[tap.view.tag - 1000]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];

    [WXPhotoBrowser showImageInView:self.view.window selectImageIndex:tap.view.tag - 1000 delegate:self];
}

- (void)setloopView{
//    if ( _loopView == nil) {
//        _loopView = [[LoopView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight)];
//        _loopView.tag = 666;
//        _loopView.hidden = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        [_loopView addGestureRecognizer:tap];
//        
//        [self.view addSubview:_loopView];
//    }
}

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
