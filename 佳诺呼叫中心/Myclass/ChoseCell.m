//
//  ChoseCell.m
//  WMS_APP_IOS
//
//  Created by jp123 on 2016/10/12.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "ChoseCell.h"

@implementation ChoseCell


-(void)layoutSubviews{
    [super layoutSubviews];

    //根据ischose显示对号
    if (self.model.isChose) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
