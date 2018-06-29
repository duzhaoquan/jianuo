//
//  TextFieldTableViewCell.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/28.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TextFieldCellType){
    
    TextFieldCellTypeText,
    TextFieldCellTypeDatePiker
};

@protocol TextFieldCellDelegate <NSObject>

-(void)cellTextEndEdit:(NSString*)cellText IndexPath:(NSIndexPath*)indexPath;

@end

@interface TextFieldTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (nonatomic,weak)id<TextFieldCellDelegate>delegate;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UILabel *firstLable;
@property (nonatomic,copy)NSString *firstLableText;
@property (nonatomic,assign)TextFieldCellType textFieldCellType;
@property (nonatomic,strong)UIDatePicker*datePicker;

@end
