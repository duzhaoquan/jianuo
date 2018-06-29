//
//  MainTabBarViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/11.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "TaskfollowVC.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *nav1 = self.viewControllers[0];
    UINavigationController *nav2 = self.viewControllers[1];
    UINavigationController *nav3 = self.viewControllers[2];
    UINavigationController *nav4 = self.viewControllers[3];
    NSLog( @"%@,%@",nav1.navigationItem.title,nav2.navigationItem.title);
    if ([[USERDEFALUTS objectForKey:@"utype"]isEqualToString:@"2"]) {
        self.viewControllers = @[nav1,nav2,nav3,nav4];
    }else{
        self.viewControllers = @[nav1,nav2,nav4];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UINavigationController *)addNavigationController:(UIViewController *)viewController
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    //修改所有导航栏控制器的title属性
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //修改所有导航栏的背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"ios2_img1_04.png"] forBarMetrics:UIBarMetricsDefault];
    
    return nav;
}

- (void)jumpAPP:(NSDictionary *)dic{

//    NSLog(@"跳到某页");
    TaskfollowVC *taskFollow = [[TaskfollowVC alloc]init];
    taskFollow.model = [[TaskModel alloc]init];
    NSString *uid =  [NSString stringWithFormat:@"%@",dic[@"uid"]];
    NSString *utype = [NSString stringWithFormat:@"%@",dic[@"utype"]];
    
    NSString *uidcun = [USERDEFALUTS objectForKey:@"uid"];
    NSString *utypecun = [USERDEFALUTS objectForKey:@"utype"];
    NSLog(@"跳到某页");
    if ([uid isEqualToString:uidcun]&&[utype isEqualToString:utypecun]) {
        taskFollow.model.task_order = dic[@"order"];
        UINavigationController *nav = [self addNavigationController:taskFollow];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}


@end
