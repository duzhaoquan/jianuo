//
//  RegisterViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *textFieldacountNumber;
@property (nonatomic,strong)UITextField *textFieldOne;
@property (nonatomic,strong)UITextField *textFieldTwo;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费注册";
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
    accountNumberLabel.text = @"账    号";
    accountNumberLabel.textAlignment = NSTextAlignmentLeft;
    accountNumberLabel.textColor = [UIColor blackColor];
    accountNumberLabel.font = [UIFont systemFontOfSize:14];
    [accountNumberView addSubview:accountNumberLabel];
    
    UIView *accountNumberLineView = [[UIView alloc] initWithFrame:ZQ_RECT_CREATE(CGRectGetMaxX(accountNumberLabel.frame), 10, 1, 30)];
    accountNumberLineView.backgroundColor = kUIColorFromRGB(0xe9e9e9);
    [accountNumberView addSubview:accountNumberLineView];
    
    //账号TextField
    self.textFieldacountNumber = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, CGRectGetWidth(accountNumberView.frame) - 190, 50)];
    _textFieldacountNumber.placeholder = @"输入账号(6-20位数字或字母)";
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
    passwordLabel.text = @"密    码";
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
    [buttonCenter setTitle:@"注册" forState:UIControlStateNormal];
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
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
