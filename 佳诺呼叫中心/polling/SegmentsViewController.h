//
//  SegmentsViewController.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/1.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "BaseViewController.h"

@interface SegmentsViewController : BaseViewController

@property(nonatomic,copy) void(^dataBack)(NSDictionary*dataDic);
@property (nonatomic,strong)NSMutableDictionary *datasDic;

@end
