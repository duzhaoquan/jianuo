//
//  TextViewTableViewCell.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/28.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
@protocol TextCellDelegate <NSObject>

-(void)cellTextEndEdit:(NSString*)cellText IndexPath:(NSIndexPath*)indexPath;

@end

@interface TextViewTableViewCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic,weak)id<TextCellDelegate>delegate;
@property (nonatomic,strong)XHMessageTextView *textView;
@property (nonatomic,strong)UILabel *firstLable;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
