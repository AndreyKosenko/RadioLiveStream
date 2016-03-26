//
//  SavedShowViewController.m
//  RadioStream
//
//  Created by dev on 3/9/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "SavedShowViewController.h"
#import "SavedShowCellViewController.h"
@interface SavedShowViewController (){
    NSMutableArray *tableData;
    
    NSIndexPath *CurindexPath;
}

@end

@implementation SavedShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    tableData = [NSMutableArray arrayWithObjects: @"Egg Benedict Egg Benedict Egg Benedict Egg Benedict Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    UIApplication *app = [UIApplication sharedApplication];
    tableData = [[app scheduledLocalNotifications] mutableCopy];
    
    _showTabel.delegate = self;
    _showTabel.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"showtblCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UILocalNotification* oneEvent = [tableData objectAtIndex:indexPath.row];
    
    UILabel *title = (UILabel*) [cell viewWithTag:2];
    title.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    title.text = oneEvent.alertBody;
    NSDate* fireDate = oneEvent.fireDate;
    NSString * strTemp;
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"-EEE LLL dd"];
    strTemp = [df stringFromDate:fireDate];
    
    UILabel *lblDate = (UILabel*) [cell viewWithTag:3];
    lblDate.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    lblDate.text = strTemp;

    [df setDateFormat:@"HH:mm:ss"];
    strTemp = [df stringFromDate:fireDate];
    
    UILabel *lblTime = (UILabel*) [cell viewWithTag:4];
    lblTime.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    lblTime.text = strTemp;
    
//    UIImageView *personImage = (UIImageView*)[cell viewWithTag:4];
//    personImage.image = [UIImage imageNamed:@"person1.png"];
    
    return cell;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CurindexPath = indexPath;
    
    return indexPath;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueViewNotiCell" ]){
        SavedShowCellViewController *detail = (SavedShowCellViewController *)segue.destinationViewController;
        [detail setONotification:tableData[CurindexPath.row]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (IBAction)OnHiddenForm:(id)sender {

}
- (IBAction)OnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}


- (IBAction)onCellRemove:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.showTabel];
    CurindexPath = [self.showTabel indexPathForRowAtPoint:buttonPosition];

//    
//    UITableViewCell *cell = [self.showTabel cellForRowAtIndexPath:indexPath];
//    UILabel *title = (UILabel*) [cell viewWithTag:2];
//
    
    NSString *message = @"Do you want to remove this saved show & reminder?";

    UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Remove!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    //Display Alert Message
    [messageAlert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        UILocalNotification* oneEvent = [tableData objectAtIndex:CurindexPath.row];
        UIApplication *app = [UIApplication sharedApplication];
        [app cancelLocalNotification:oneEvent];
        
        [tableData removeObjectAtIndex:CurindexPath.row];
        [self.showTabel deleteRowsAtIndexPaths:[NSArray arrayWithObject:CurindexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
