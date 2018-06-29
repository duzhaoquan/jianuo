//
//  TxetViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/17.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TxetViewController.h"

@interface TxetViewController ()
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *keyboadView;

@end

@implementation TxetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView = [[UITextView alloc]initWithFrame:self.view.bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.text = _text;
    
    
    if (_canEdite == YES) {
        self.textView.userInteractionEnabled = YES;
       //[_textView becomeFirstResponder];
        _textView.frame = CGRectMake(10, SafeAreaTopHeight+5, kScreenwidth - 20, 300);
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor orangeColor].CGColor;
        _textView.layer.cornerRadius = 5;
        //按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(kScreenwidth/2 - 100,kScreenheight - 100, 200, 40);
        [self.view addSubview:button];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blueColor].CGColor;
        
        button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
        
        [button addTarget:self action:@selector(backAcion) forControlEvents:UIControlEventTouchUpInside];
        
        //键盘完成与取消视图
        _keyboadView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenheight, kScreenwidth, 40)];
        [self.view addSubview:_keyboadView];
        _keyboadView.backgroundColor = [UIColor grayColor];
        
        UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
        finish.frame = _keyboadView.bounds;
        [finish setTitle:@"完成" forState:UIControlStateNormal];
        [finish setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [finish addTarget:self action:@selector(keyBoadAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_keyboadView addSubview:finish];
        //监听键盘出现和消失
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }else{
        self.textView.userInteractionEnabled = NO;
    }
    
}

//键盘确定和取消
- (void)keyBoadAction:(UIButton *)button{
    
        [self.view endEditing:YES];
}

-(void)backAcion{
    if (_backText != nil) {
        _backText(_textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:.35 animations:^{
        _keyboadView.frame = CGRectMake(0, kScreenheight - keyBoardRect.size.height - 40 , kScreenwidth, 40);
        
    }];
}

#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:.35 animations:^{
        _keyboadView.frame = CGRectMake(0, kScreenheight , kScreenwidth, 40);
        
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
