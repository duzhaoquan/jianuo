//
//  ChangePasswordViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/24.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginViewController.h"
#import "LoginNavigationVC.h"
#import "JPUSHService.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textFieldacountNumber;
@property (nonatomic,strong)UITextField *textFieldOne;
@property (nonatomic,strong)UITextField *textFieldTwo;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    //点击键盘消失
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressedKeybordHidden)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指
    singleFingerOne.numberOfTapsRequired = 1;    //tap次数
    singleFingerOne.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleFingerOne];
    
    UIView *accountNumberView = [[UIView alloc] initWithFrame:CGRectMake(10, 74, kScreenwidth - 20, 50)];
    accountNumberView.backgroundColor = [UIColor whiteColor];
    accountNumberView.layer.borderWidth = 1.0f;
    accountNumberView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[accountNumberView layer] setCornerRadius:5.];
    [[accountNumberView layer] setMasksToBounds:YES];
    [self.view addSubview:accountNumberView];
    
    UILabel *accountNumberLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 50)];
    accountNumberLabel.text = @"原  密  码";
    accountNumberLabel.textAlignment = NSTextAlignmentLeft;
    accountNumberLabel.textColor = [UIColor blackColor];
    accountNumberLabel.font = [UIFont systemFontOfSize:14];
    [accountNumberView addSubview:accountNumberLabel];
    
    UIView *accountNumberLineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(accountNumberLabel.frame), 10, 1, 30)];
    accountNumberLineView.backgroundColor = kUIColorFromRGB(0xe9e9e9);
    [accountNumberView addSubview:accountNumberLineView];
    
    //账号TextField
    self.textFieldacountNumber = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, CGRectGetWidth(accountNumberView.frame) - 190, 50)];
    _textFieldacountNumber.placeholder = @"输入密码(6-20位数字或字母)";
    _textFieldacountNumber.textAlignment = NSTextAlignmentLeft;
    _textFieldacountNumber.keyboardType = UIKeyboardTypeDefault;
    _textFieldacountNumber.tag = 10;
    _textFieldacountNumber.font = [UIFont systemFontOfSize:14.f];
    _textFieldacountNumber.delegate = self;
    [_textFieldacountNumber setKeyboardType:UIKeyboardTypeDefault];
    [_textFieldacountNumber setReturnKeyType:UIReturnKeyDone];
    [accountNumberView addSubview:_textFieldacountNumber];
    
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(10, 134, kScreenwidth - 20, 50)];
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordView.layer.borderWidth = 1.0f;
    passwordView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[passwordView layer] setCornerRadius:5.];
    [[passwordView layer] setMasksToBounds:YES];
    [self.view addSubview:passwordView];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 50)];
    passwordLabel.text = @"新  密  码";
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.textColor = [UIColor blackColor];
    passwordLabel.font = [UIFont systemFontOfSize:14];
    [passwordView addSubview:passwordLabel];
    
    UIView *passwordLineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(passwordLabel.frame), 10, 1, 30)];
    passwordLineView.backgroundColor = kUIColorFromRGB(0xe9e9e9);
    [passwordView addSubview:passwordLineView];
    
    //新密码TextField
    self.textFieldOne = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, CGRectGetWidth(accountNumberView.frame) - 100, 50)];
    _textFieldOne.placeholder = @"输入密码(6-20位数字或字母)";
    _textFieldOne.textAlignment = NSTextAlignmentLeft;
    _textFieldOne.keyboardType = UIKeyboardTypeDefault;
    _textFieldOne.tag = 30;
    _textFieldOne.font = [UIFont systemFontOfSize:14.f];
    _textFieldOne.delegate = self;
    _textFieldOne.clearsOnBeginEditing = YES;       //再次编辑的时候，清空内部文字
    _textFieldOne.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_textFieldOne setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldOne setReturnKeyType:UIReturnKeyDone];
    [passwordView addSubview:_textFieldOne];
    
    UIView *passwordView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 194, kScreenwidth - 20, 50)];
    passwordView1.backgroundColor = [UIColor whiteColor];
    passwordView1.layer.borderWidth = 1.0f;
    passwordView1.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[passwordView1 layer] setCornerRadius:5.];
    [[passwordView1 layer] setMasksToBounds:YES];
    [self.view addSubview:passwordView1];
    
    UILabel *passwordLabel1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 50)];
    passwordLabel1.text = @"确认密码";
    passwordLabel1.textAlignment = NSTextAlignmentLeft;
    passwordLabel1.textColor = [UIColor blackColor];
    passwordLabel1.font = [UIFont systemFontOfSize:14];
    [passwordView1 addSubview:passwordLabel1];
    
    UIView *passwordLineView1 = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(passwordLabel.frame), 10, 1, 30)];
    passwordLineView1.backgroundColor = kUIColorFromRGB(0xe9e9e9);
    [passwordView1 addSubview:passwordLineView1];
    
    //确认密码TextField
    self.textFieldTwo = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, CGRectGetWidth(accountNumberView.frame) - 100, 50)];
    _textFieldTwo.placeholder = @"再次输入密码";
    _textFieldTwo.textAlignment = NSTextAlignmentLeft;
    _textFieldTwo.keyboardType = UIKeyboardTypeDefault;
    _textFieldTwo.tag = 40;
    _textFieldTwo.font = [UIFont systemFontOfSize:14.f];
    _textFieldTwo.delegate = self;
    _textFieldTwo.clearsOnBeginEditing = YES;       //再次编辑的时候，清空内部文字
    _textFieldTwo.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_textFieldTwo setKeyboardType:UIKeyboardTypeASCIICapable];
    [_textFieldTwo setReturnKeyType:UIReturnKeyDone];
    [passwordView1 addSubview:_textFieldTwo];
    
    UIButton *buttonCenter = [UIButton buttonWithType:UIButtonTypeSystem];
    [buttonCenter setFrame:CGRectMake(10, CGRectGetMaxY(passwordView1.frame) + 20, kScreenwidth - 20, 50)];
    [buttonCenter setTitle:@"修改密码" forState:UIControlStateNormal];
    [buttonCenter setTintColor:kUIColorFromRGB(0xffffff)];
    buttonCenter.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[buttonCenter layer] setCornerRadius:5.];
    [[buttonCenter layer] setMasksToBounds:YES];
    [buttonCenter setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xfb7caf)] forState:UIControlStateNormal];
    [buttonCenter addTarget:self action:@selector(buttonPressedClickStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCenter];
    
    
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//键盘隐藏
-(void)buttonPressedKeybordHidden
{
    
    
}
-(void)buttonPressedClickStatus:(UIButton*)button{
    if ( ![_textFieldTwo.text isEqualToString:_textFieldOne.text]) {
        
        [WCAlertView showAlertWithTitle:@"提示" message:@"两次密码不一致" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    
    [self.textFieldTwo resignFirstResponder];
    [self.textFieldOne resignFirstResponder];
    [self.textFieldacountNumber resignFirstResponder];
    
    __weak ChangePasswordViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"old_pwd"] = _textFieldacountNumber.text;
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"pwd"] = _textFieldOne.text;
    params[@"new_pwd"] = _textFieldTwo.text;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/up_info"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        [weakSelf showHint:responseObject[@"msg"]];
        if ([responseObject[@"code"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf logout];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
    
}


-(void)logout{
    
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
