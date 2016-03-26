//
//  ScheduleMoreViewController.m
//  RadioStream
//
//  Created by dev on 3/11/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ScheduleMoreViewController.h"
#import "getData.h"
#import <AFNetworking/AFNetworking.h>

@interface ScheduleMoreViewController ()

@end

@implementation ScheduleMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *oneDic = [ScheduleData objectForKey:self.strCellID];
    self.scheduleTitle.text = [oneDic objectForKey:@"schedule_title"];
    self.scheduleMore.text = [oneDic objectForKey:@"schedule_des"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)OnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)onSetReminder:(id)sender {
    NSString *message = @"Do you want to add this saved show & reminder?";
    
    UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Set reminder!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    //Display Alert Message
    [messageAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        NSLog(@"startLocalNotification");
        
        NSDictionary *oneDic = [ScheduleData objectForKey:self.strCellID];
        NSString* strTime;
        strTime = [oneDic objectForKey:@"schedule_time"];
        
        NSString *dateString = [oneDic objectForKey:@"schedule_date"];
        if ([strTime intValue] > 7) { // setting date + 1
            NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
            formatterDate.dateFormat = @"yyyy-MM-dd";
            
            NSDate *settingDate = [[NSDate alloc] init];
            settingDate = [formatterDate dateFromString:dateString];
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit unit = NSCalendarUnitDay;
            NSInteger value = 1;
            settingDate = [calendar dateByAddingUnit:unit value:value toDate:settingDate options:NSCalendarMatchStrictly];
            dateString = [formatterDate stringFromDate:settingDate];
        }
        
        switch ([strTime intValue]) {
            case 0:
                strTime = @" 09:00:00";
                break;
            case 1:
                strTime = @" 11:00:00";
                break;
            case 2:
                strTime = @" 13:00:00";
                break;
            case 3:
                strTime = @" 15:00:00";
                break;
            case 4:
                strTime = @" 17:00:00";
                break;
            case 5:
                strTime = @" 19:00:00";
                break;
            case 6:
                strTime = @" 21:00:00";
                break;
            case 7:
                strTime = @" 23:00:00";
                break;
            case 8:
                strTime = @" 01:00:00";
                break;
            case 9:
                strTime = @" 03:00:00";
                break;
            case 10:
                strTime = @" 05:00:00";
                break;
            case 11:
                strTime = @" 07:00:00";
                break;
        }
        
        
        dateString = [dateString stringByAppendingString:strTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:dateString];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        [infoDict setValue:self.strCellID forKey:@"key"];
        
        [infoDict setValue:[oneDic objectForKey:@"img"] forKey:@"img"];
        [infoDict setValue:[oneDic objectForKey:@"schedule_date"] forKey:@"schedule_date"];
        [infoDict setValue:[oneDic objectForKey:@"schedule_time"] forKey:@"schedule_time"];
        [infoDict setValue:[oneDic objectForKey:@"schedule_des"] forKey:@"schedule_des"];
        [notification setUserInfo:infoDict];

        //notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        notification.fireDate = dateFromString;
        
        //notification.alertBody = self.scheduleMore.text;
        notification.alertBody = self.scheduleTitle.text;
        notification.alertTitle = @"SWU FM";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
