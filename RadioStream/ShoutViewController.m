//
//  ShoutViewController.m
//  RadioStream
//
//  Created by dev on 3/9/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ShoutViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
@interface ShoutViewController ()

@end

@implementation ShoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)onSendSmsPhone:(id)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"SMS message here";
        controller.recipients = [NSArray arrayWithObjects:@"0(733)983-1201", nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

//- (IBAction)onSendEMail:(id)sender {
//        // Email Subject
//        NSString *emailTitle = @"to Studio@swu.fm";
//        // Email Content
//        NSString *messageBody = @"email body";
//        // To address
//        NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
//    
//        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//        mc.mailComposeDelegate = self;
//        [mc setSubject:emailTitle];
//        [mc setMessageBody:messageBody isHTML:NO];
//        [mc setToRecipients:toRecipents];
//    
//        // Present mail view controller on screen
//        [self presentViewController:mc animated:YES completion:NULL];
//}
//- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            NSLog(@"Mail cancelled");
//            break;
//        case MFMailComposeResultSaved:
//            NSLog(@"Mail saved");
//            break;
//        case MFMailComposeResultSent:
//            NSLog(@"Mail sent");
//            break;
//        case MFMailComposeResultFailed:
//            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
//            break;
//        default:
//            break;
//    }
//
//    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

- (IBAction)onSendEMail:(id)sender {
 
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"to Studio@swu.fm"];
        [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
        [mail setToRecipients:@[@"Studio@swu.fm"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)onTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/SWUfm"]];
}

- (IBAction)onFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/swu.fm/"]];
}

- (IBAction)onInstagram:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.instagram.com/swu.fm/"]];
}

- (IBAction)onSoundcloud:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://soundcloud.com/swufm"]];
}

@end
