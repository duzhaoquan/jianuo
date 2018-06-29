//
//  LoginViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/13.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "RegisterViewController.h"
#import "UserModel.h"
#import "JPUSHService.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SSKeychain.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *phoneNumberTextField;
@property (nonatomic,strong)UITextField *passwordTextField;
@property (nonatomic,assign)CGFloat safeArea;
@property (nonatomic,strong)UserModel *userModel;
@property (nonatomic,strong)UIButton *registerBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _safeArea = 104;
    if (kScreenheight == 812) {
        _safeArea += 24;
    }
    
    //TempDefine
    //账号、密码
    UIView *uidView = [[UIView alloc] initWithFrame:CGRectMake(10, 10+ _safeArea, self.view.frame.size.width - 20, 100)];
    uidView.backgroundColor = [UIColor whiteColor];
    uidView.layer.borderWidth = 1.0f;
    uidView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[uidView layer] setCornerRadius:7.];
    [[uidView layer] setMasksToBounds:YES];
    [self.view addSubview:uidView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 80, 50)];
    label.text = @"账号";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label];
    
    //手机号TextField
    self.phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, CGRectGetWidth(uidView.frame) - 90, 50)];
    _phoneNumberTextField.placeholder = @"请输入账号";
    
    
    _phoneNumberTextField.textAlignment = NSTextAlignmentLeft;
    _phoneNumberTextField.borderStyle = UITextBorderStyleNone;
    _phoneNumberTextField.font = [UIFont systemFontOfSize:15.f];
    [_phoneNumberTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _phoneNumberTextField.delegate = self;
    //设置键盘的样式
    //_phoneNumberTextField.keyboardType = UIKeyboardTypeDefault;
    _phoneNumberTextField.returnKeyType = UIReturnKeyDone;
    [uidView addSubview:_phoneNumberTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 2000, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xe2e2e2);
    [uidView addSubview:lineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 50, 80, 50)];
    label1.text = @"密码";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label1];
    
    
    
    //密码TextField
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 50, CGRectGetWidth(uidView.frame) - 90, 50)];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordTextField.font = [UIFont systemFontOfSize:15.f];
    _passwordTextField.delegate = self;
    _passwordTextField.clearsOnBeginEditing = YES;       //再次编辑的时候，清空内部文字
    _passwordTextField.secureTextEntry = YES;            //使内容以保密圆点方式显示
    [_passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [_passwordTextField setReturnKeyType:UIReturnKeyDone];
    [uidView addSubview:_passwordTextField];
    
    
    //登录button
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(10, CGRectGetMaxY(uidView.frame) + 20, self.view.frame.size.width - 20, 50);
    
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton setTintColor:kUIColorFromRGB(0xffffff)];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[loginButton layer] setCornerRadius:5.];
    [[loginButton layer] setMasksToBounds:YES];
    [loginButton setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xfb7caf)] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.frame = CGRectMake(10, CGRectGetMaxY(loginButton.frame) + 20, self.view.frame.size.width - 20, 50);
    
    
    [registerButton setTitle:@"指纹验证" forState:UIControlStateNormal];
    [registerButton setTintColor:kUIColorFromRGB(0xffffff)];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [[registerButton layer] setCornerRadius:5.];
    [[registerButton layer] setMasksToBounds:YES];
    [registerButton setBackgroundImage:[self imageWithColor:kUIColorFromRGB(0xfb7caf)] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:registerButton];
    
    
    
    NSString *name = [USERDEFALUTS objectForKey:@"username"];
   
    
    if (![ZQ_CommonTool isEmpty:name]) {
        _phoneNumberTextField.text = name;
    }else {
        registerButton.hidden = YES;
    }
    self.registerBtn = registerButton;
    
    
    //提取用户密码
    if (self.phoneNumberTextField.text.length > 0) {
        NSError * error = nil;
        self.passwordTextField.text = [SSKeychain passwordForService:@"jianuo.com" account:self.phoneNumberTextField.text error:&error];
        if (error) {
            NSLog(@"error = %@",error);
        }
    }
    
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (![_phoneNumberTextField.text isEqualToString: [USERDEFALUTS objectForKey:@"username"]]) {
        self.registerBtn.hidden = YES;
    }else{
        self.registerBtn.hidden = NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//登录
- (void)loginButtonClick:(UIButton*)button {
    
    __weak LoginViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = _phoneNumberTextField.text;
    params[@"password"] = _passwordTextField.text;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/login"];
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //NSLog(@"progress");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        //NSLog(@"success");
        //NSLog(@"responseObject = %@",responseObject);
        NSDictionary *response = (NSDictionary *)responseObject;
        if ([response[@"code"] integerValue] == 1) {
            
            NSError * error = nil;
            BOOL succe =  [SSKeychain setPassword:self.passwordTextField.text forService:@"jianuo.com" account:self.phoneNumberTextField.text error:&error];
            NSLog(@"succ = %d",succe);
            if (error) {
                NSLog(@"error = %@",error);
            }
            
            [weakSelf showHint:response[@"msg"] yOffset:-100];
            _userModel = [UserModel objectWithKeyValues:response[@"listData"]];
            [USERDEFALUTS setObject:_phoneNumberTextField.text forKey:@"username"];
            [USERDEFALUTS setObject:_userModel.uid forKey:@"uid"];
            [USERDEFALUTS setObject:_userModel.user_id forKey:@"user_id"];
            [USERDEFALUTS setObject:_userModel.utype forKey:@"utype"];
            [USERDEFALUTS setObject:_userModel.group_id forKey:@"group_id"];
            [USERDEFALUTS setObject:_userModel.area_id forKey:@"area_id"];
            [USERDEFALUTS synchronize];
            NSString *alia;
            if ([_userModel.utype isEqualToString:@"1"]) {
                alia = [NSString stringWithFormat:@"customer%@",_userModel.uid];
            }else{
                alia = [NSString stringWithFormat:@"member%@",_userModel.uid];
            }
             
            //极光推送别名   
            [JPUSHService setAlias:alia completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"iResCode = %ld",iResCode);
            } seq:123];
            //通过storyboard获取标签控制器
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainTabBarViewController *mian = [storyboard instantiateInitialViewController];
            //改变window的根视图控制器
            [UIApplication sharedApplication].delegate.window.rootViewController = mian;
            
        }else{
            [weakSelf showHint:response[@"msg"] yOffset:-100];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        NSLog(@"%@",error);
    }];
}

//
- (void)registerButtonClick:(UIButton*)button {
//    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
//    [self.navigationController pushViewController:registerVC animated:YES];
    
    //钥匙串,打印所有账户
    NSLog(@"%@",[SSKeychain allAccounts]);
    
    //创建LAContext
    LAContext *context = [LAContext new]; //这个属性是设置指纹输入失败之后的弹出框的选项
//    context.localizedFallbackTitle = @"没有忘记密码";
//    context.localizedCancelTitle = @"取消按钮文字";
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
                             error:&error]) {
        NSLog(@"支持指纹识别");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
                localizedReason:@"指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"验证成功 刷新主界面");
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            //提取用户密码
                            if (self.phoneNumberTextField.text.length > 0) {
                                NSError * error = nil;
                                self.passwordTextField.text = [SSKeychain passwordForService:@"jianuo.com" account:self.phoneNumberTextField.text error:&error];
                                if (error) {
                                    NSLog(@"error = %@",error);
                                }
                                
                                [self loginButtonClick:nil];
                            }
                        });
                        
                    }else{
                        NSLog(@"%@",error.localizedDescription);
                        switch (error.code) {
                            case LAErrorSystemCancel:
                            {
                                NSLog(@"系统取消授权，如其他APP切入");
                                break;
                            }
                            case LAErrorUserCancel:
                            {
                                NSLog(@"用户取消验证Touch ID");
                                break;
                            }
                            case LAErrorAuthenticationFailed:
                            {
                                NSLog(@"授权失败");
                                break;
                            }
                            case LAErrorPasscodeNotSet:
                            {
                                NSLog(@"系统未设置密码");
                                break;
                            }
                            case LAErrorTouchIDNotAvailable:
                            {
                                NSLog(@"设备Touch ID不可用，例如未打开");
                                break;
                            }
                            case LAErrorTouchIDNotEnrolled:
                            {
                                NSLog(@"设备Touch ID不可用，用户未录入");
                                break;
                            }
                            case LAErrorUserFallback:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    NSLog(@"用户选择输入密码，切换主线程处理");
                                }];
                                break;
                            }
                            default:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    NSLog(@"其他情况，切换主线程处理");
                                }];
                                break;
                            }
                        }
                    }
                }];
    }else{
        NSLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
    
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

@end
