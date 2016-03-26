//
//  HomeViewController.m
//  RadioStream
//
//  Created by dev on 3/6/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "HomeViewController.h"
#import "ShoutViewController.h"
#import "SavedShowViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnRadioSchedule;
@property (weak, nonatomic) IBOutlet UIButton *btnMySavedShow;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onListenLive:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}
- (IBAction)onRadioSchedule:(id)sender {
    [self.tabBarController setSelectedIndex:2];
}
- (IBAction)onMySavedShow:(id)sender {
}
- (IBAction)onShoutOut:(id)sender {
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"shoutSegue" ]){
        ShoutViewController *detail = (ShoutViewController *)segue.destinationViewController;
        [self setPresentationStyleForSelfController:self presentingController:detail];
    
    }else if ([segue.identifier isEqualToString:@"savedshowSegue" ]){
        SavedShowViewController *detail = (SavedShowViewController *)segue.destinationViewController;
        [self setPresentationStyleForSelfController:self presentingController:detail];
    }
    
}
- (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
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
