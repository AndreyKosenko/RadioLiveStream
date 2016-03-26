//
//  TabViewController.m
//  RadioStream
//
//  Created by dev on 3/7/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect tabbarFrame = self.tabBarController.tabBar.frame;
    tabbarFrame.size.height += 60;
    self.tabBarController.tabBar.frame = tabbarFrame;
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"tabBackground5.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    self.tabBarController.tabBar.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth ;
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage imageNamed:@"tabSelect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 3, 0)]];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
