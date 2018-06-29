//
//  DropDown.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/7.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "DropDown.h"
#import "Fault.h"
#import "CustomerModel.h"
#import "BrandModel.h"
@implementation DropDown



-(id)initWithFrame:(CGRect)frame

{
    
    if (frame.size.height<300) {
        
        _frameHeight =300;
        
    }else{
        
        _frameHeight = frame.size.height;
        
    }
    
    _tabheight = _frameHeight-30;
    
    frame.size.height = 30.0f;
    
    _beginFram = frame;
    self=[super initWithFrame:frame];
    
    if(self){
        
        _showList = NO; //默认不显示下拉框
        
       
        _tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, frame.size.width,300) style:UITableViewStyleGrouped];
        _tv.backgroundColor = [UIColor colorWithRed:250/255.0 green:235/255.0 blue:215/255.0 alpha:1];
        _tv.delegate = self;
        
        _tv.dataSource = self;
        
        _tv.separatorColor = [UIColor lightGrayColor];
        
        _tv.hidden = YES;
        
        _tv.contentOffset =CGPointMake(0, 64);
        
        [self addSubview:_tv];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
        _textField.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框风格
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_textField.frame)-30, 7.5, 15, 15)];
        
        image.image = [UIImage imageNamed:@"jian.jpg"];
        image.tag = 1200;
        //image.userInteractionEnabled = YES;
        [_textField addSubview:image];
        [_textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
        
        _textField.font = [UIFont systemFontOfSize:16];
        
        _textField.placeholder = @"请选择(点击)";
        
        //KVO
        [_textField addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        //设置textfield 不弹出键盘
        
        _textField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
        
        _textField.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        
        [self addSubview:_textField];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
        
        self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        //省  市
        
        self.provinceArray = [self.pickerDic allKeys];
        
        _tableArray = self.provinceArray;
        
    }
    
    return self;
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"frame"])
    {
        UIView *view = [self.textField viewWithTag:1200];
        view.frame = CGRectMake(CGRectGetMaxX(_textField.frame)-30, CGRectGetHeight(_textField.frame)/2 - 7.5, 15, 15);
        _tv.frame = CGRectMake(0, CGRectGetHeight(_textField.frame)+1, self.frame.size.width,300);
    }
}

- (void)dealloc{
    [self.textField removeObserver:self forKeyPath:@"frame"];
}

-(void)setTableArray:(NSArray *)tableArray{
    _tableArray = tableArray;
    [_tv reloadData];
}
//不展示列表
-(void)dontshowlist

{
//    self.frame = _beginFram;
    _showList = NO;
    
    _tv.hidden = YES;
    
    CGRect sf = self.frame;
    
    sf.size.height = 30;
    
    self.frame = sf;
    
    CGRect frame = _tv.frame;
    
    frame.size.height = 0;
    
    _tv.frame = frame;
    
}

-(void)dropdown

{
    
    [_textField resignFirstResponder];
    
    if (_showList) {//如果下拉框已显示，则收回
        [_textField resignFirstResponder];
        
        return;
        
    }else {//如果下拉框尚未显示，则进行显示
        [_textField resignFirstResponder];
        CGRect sf = self.frame;
        
        sf.size.height = _frameHeight;
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        
        [self.superview bringSubviewToFront:self];
        
        _tv.hidden = NO;
        
        _showList = YES;//显示下拉框
        
        _tv.tableHeaderView.backgroundColor = [UIColor blackColor];
        
        CGRect frame = _tv.frame;
        
        frame.size.height = 0;
        
        _tv.frame = frame;
        
        frame.size.height = _tabheight;
        frame.size.width = kScreenwidth;
        frame.origin.x = -sf.origin.x;
        
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        
        self.frame = sf;
        
        _tv.frame = frame;
        
        [UIView commitAnimations];
        
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 40)];
    UILabel *lable = [[UILabel alloc]initWithFrame:headView.frame];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"不限";
    lable.userInteractionEnabled = YES;
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [lable addGestureRecognizer:tap];
    [headView addSubview:lable];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return [_tableArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
    
    //cell.backgroundColor = [UIColor grayColor];
    cell.backgroundColor = _tv.backgroundColor = [UIColor colorWithRed:250/255.0 green:235/255.0 blue:215/255.0 alpha:1];
    NSObject *obj = [_tableArray objectAtIndex:[indexPath row]];
    if ([obj isKindOfClass:[Fault class]]) {
        Fault *fault = (Fault*)obj; 
        cell.textLabel.text = fault.fault_name;
    }else if ([obj isKindOfClass:[CustomerModel class]]){
        CustomerModel *model = (CustomerModel*)obj;
        cell.textLabel.text = model.customer_name;
    }else if ([obj isKindOfClass:[BrandModel class]]){
        BrandModel *model = (BrandModel*)obj;
        cell.textLabel.text = model.brands_name;
    }else{
        cell.textLabel.text = [_tableArray objectAtIndex:[indexPath row]];
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 35;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSObject *obj = [_tableArray objectAtIndex:[indexPath row]];
    if ([obj isKindOfClass:[Fault class]]) {
        Fault *fault = (Fault*)obj; 
        _textField.text = fault.fault_name;
    }else if ([obj isKindOfClass:[CustomerModel class]]){
        CustomerModel *model = (CustomerModel*)obj;
        _textField.text = model.customer_name;
    }else if ([obj isKindOfClass:[BrandModel class]]){
        BrandModel *model = (BrandModel*)obj;
        _textField.text = model.brands_name;
    }else{
        _textField.text = [_tableArray objectAtIndex:[indexPath row]];
    }

    
    _showList = NO;
    
    _tv.hidden = YES;
    
    CGRect sf = self.frame;
    
    sf.size.height = 30;
    
    self.frame = sf;
    
    CGRect frame = _tv.frame;
    
    frame.size.height = 0;
    
    _tv.frame = frame;
    
    NSString *string = [NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:string,@"index",nil];
    
    if(self.name ==nil){
        self.name = @"通知";
    }
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:self.name object:nil userInfo:dict];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

-(void)tapAction:(UITapGestureRecognizer*)tap{
    
    [self dontshowlist];
    _textField.text = @"";
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"-1",@"index",nil];
    
    if(self.name ==nil){
        self.name = @"通知";
    }
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:self.name object:nil userInfo:dict];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
