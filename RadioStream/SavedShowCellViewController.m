//
//  SavedShowCellViewController.m
//  RadioStream
//
//  Created by dev on 3/17/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "SavedShowCellViewController.h"
#import <AFNetworking/AFNetworking.h>
@implementation SavedShowCellViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *oneDic = _oNotification.userInfo;
    //self.scheduleTitle.text = _oNotification.alertTitle;
    
    self.scheduleTitle.text = _oNotification.alertBody;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *orignalDate   =  [dateFormatter dateFromString:[oneDic objectForKey:@"schedule_date"]];
    [dateFormatter setDateFormat:@"-EEE LLL dd"];
    self.scheduleDate.text = [dateFormatter stringFromDate:orignalDate];
    NSString *strTemp;
    strTemp = [oneDic objectForKey:@"schedule_time"];
    
    switch ([strTemp intValue]) {
        case 0:
            self.scheduleTime.text = @"09:00 - 11:00";
            break;
        case 1:
            self.scheduleTime.text = @"11:00 - 13:00";
            break;
        case 2:
            self.scheduleTime.text = @"13:00 - 15:00";
            break;
        case 3:
            self.scheduleTime.text = @"15:00 - 17:00";
            break;
        case 4:
            self.scheduleTime.text = @"17:00 - 19:00";
            break;
        case 5:
            self.scheduleTime.text = @"19:00 - 21:00";
            break;
        case 6:
            self.scheduleTime.text = @"21:00 - 23:00";
            break;
        case 7:
            self.scheduleTime.text = @"23:00 - 01:00";
            break;
        case 8:
            self.scheduleTime.text = @"01:00 - 03:00";
            break;
        case 9:
            self.scheduleTime.text = @"03:00 - 05:00";
            break;
        case 10:
            self.scheduleTime.text = @"05:00 - 07:00";
            break;
        case 11:
            self.scheduleTime.text = @"07:00 - 09:00";
            break;
    }
    [self.picloader setHidesWhenStopped:YES];
    [self.picloader startAnimating];
    
    self.scheduleMore.text = [oneDic objectForKey:@"schedule_des"];
    
    // image view
    //strTemp = [oneDic objectForKey:@"img"];
    strTemp = [oneDic objectForKey:@"img"];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[strTemp stringByReplacingOccurrencesOfString:@"image.png" withString:@"image.png"]]]];
    [requestOperation setResponseSerializer:[AFImageResponseSerializer serializer]];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.picloader stopAnimating];
        self.s_image.image = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.picloader stopAnimating];
        self.s_image.image = [UIImage imageNamed:@"image.png"];
    }];
    [requestOperation start];
    
    [self.view sendSubviewToBack:self.s_image];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}


@end
