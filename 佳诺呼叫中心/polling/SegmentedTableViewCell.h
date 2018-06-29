//
//  SegmentedTableViewCell.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/1.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SegmentedCellDelegate <NSObject>

-(void)cellTextEndEdit:(NSString*)cellText IndexPath:(NSIndexPath*)indexPath;

@end

@interface SegmentedTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *firstLable;
@property (nonatomic,copy)NSString *firstLableText;
@property (nonatomic,strong)UISegmentedControl *segControl;
@property (nonatomic,weak)id<SegmentedCellDelegate>delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
