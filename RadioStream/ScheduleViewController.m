//
//  ScheduleViewController.m
//  RadioStream
//
//  Created by dev on 3/11/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleMoreViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "getData.h"

@interface ScheduleViewController () <XCMultiTableViewDataSource, XCMultiTableViewDelegate>

@property (strong, nonatomic) MBProgressHUD *loader;
@property (strong, nonatomic) NSString *curCellID;
@end

@implementation ScheduleViewController{
    NSMutableArray *headData;
    NSMutableArray *leftTableData;
    NSMutableArray *rightTableData;
    
    XCMultiTableView *tableViewObj;

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    
    [self show_TableView];
    [self getRequestData];
    [self GetScheduleData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"scheduleMoreSegue" ]){
        ScheduleMoreViewController *detail = (ScheduleMoreViewController *)segue.destinationViewController;
        [detail setStrCellID:self.curCellID];
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
/// schedule view /////////////////

- (void) myCall:(int)iRow Column:(int)iCol view:(UIView*)CellView leftHeaderString:(NSString *)leftHeaderStr{
    if (CellView.tag == 0) {
        [self show_toast:@"empty cell!"];
        return;
    }
    self.curCellID = [NSString stringWithFormat:@"%ld", (long)CellView.tag];
    [self performSegueWithIdentifier:@"scheduleMoreSegue" sender:self];
}
-(void)initTable{
    if (orderedDateKeys == nil) {
        orderedDateKeys = [[NSMutableArray alloc]init];
    }else{
        [orderedDateKeys removeAllObjects];
        orderedDateKeys = nil;
        orderedDateKeys = [[NSMutableArray alloc]init];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;
    
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
    formatterDate.dateFormat = @"yyyy-MM-dd";
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatterComp = [[NSDateFormatter alloc] init];
    formatterComp.dateFormat = @"yyyy-MM-dd 09:00:00";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *fday = [formatterComp stringFromDate:today];
    
    NSDate *dateComp9 = [[NSDate alloc] init];
    dateComp9 = [formatter dateFromString:fday];
    
    if ([today compare:dateComp9] == NSOrderedAscending) {  // dateComp9 > today
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay;
        NSInteger value = -1;
        today = [calendar dateByAddingUnit:unit value:value toDate:today options:NSCalendarMatchStrictly];
    }
    
    NSDate *sdayDate;
    NSString * strDate;
    for (int ii = 0; ii<7; ii++) {
        sdayDate = [calendar dateByAddingUnit:unit value:ii toDate:today options:NSCalendarMatchStrictly];
        strDate = [formatterDate stringFromDate:sdayDate];
        [orderedDateKeys addObject:strDate];
    }
    NSUInteger iCnt = [orderedDateKeys count];
    
    headData = [NSMutableArray arrayWithCapacity:iCnt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    for (int ii = 0; ii<iCnt; ii++) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *orignalDate   =  [dateFormatter dateFromString:orderedDateKeys[ii]];
        
        [dateFormatter setDateFormat:@"-EEE LLL dd"];
        NSString *finalString = [dateFormatter stringFromDate:orignalDate];
        [headData addObject:finalString];
    }
    
    leftTableData = [NSMutableArray arrayWithCapacity:12];
    NSMutableArray *one = [NSMutableArray arrayWithCapacity:12];
    
    [one addObject:@"09-00 - 11-00"];
    [one addObject:@"11-00 - 13-00"];
    [one addObject:@"13-00 - 15-00"];
    [one addObject:@"15-00 - 17-00"];
    [one addObject:@"17-00 - 19-00"];
    [one addObject:@"19-00 - 21-00"];
    [one addObject:@"21-00 - 23-00"];
    [one addObject:@"23-00 - 01-00"];
    [one addObject:@"01-00 - 03-00"];
    [one addObject:@"03-00 - 05-00"];
    [one addObject:@"05-00 - 07-00"];
    [one addObject:@"07-00 - 09-00"];
    
    [leftTableData addObject:one];
    
    rightTableData = [NSMutableArray arrayWithCapacity:10];
    
    NSMutableArray *oneR = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 12; i++) {
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:10];
        for (int j = 0; j < iCnt; j++) {
            [ary addObject:[NSString stringWithFormat:@""]]; // empty cells
        }
        [oneR addObject:ary];
    }
    

    [rightTableData addObject:oneR];
}
- (void)initData {
    NSUInteger iCnt = [orderedDateKeys count];
    NSString *strDate, *strID;
    NSMutableArray *oneR = rightTableData[0];
    
    
    for (int iCol = 0; iCol < iCnt; iCol++) {
        strDate = orderedDateKeys[iCol];
        for(int jj = 0; jj<12;jj++) {
            oneR[jj][iCol] = @"";
        }
    }
    
    
    for (int iCol = 0; iCol < iCnt; iCol++) {
        strDate = orderedDateKeys[iCol];
        for(NSDictionary *r in ScheduleDataArry) {
            if ([strDate isEqualToString:[r objectForKey:@"schedule_date"]]) {
                strID = [r objectForKey:@"id"];
                int iSchedule_Time = [[r objectForKey:@"schedule_time"] intValue];
                oneR[iSchedule_Time][iCol] = [r objectForKey:@"id"];
            }
        }
    }

}

-(void)GetScheduleData{
    
    
}
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView {
    return [headData copy];
}
- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [leftTableData objectAtIndex:section];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section {
    return [rightTableData objectAtIndex:section];
}


- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView {
    return [leftTableData count];
}

- (AlignHorizontalPosition)tableView:(XCMultiTableView *)tableView inColumn:(NSInteger)column {
    return AlignHorizontalPositionCenter;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column {
    return 200.0f;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section {
    if (section == 0) {
        return 60.0f;
    }else {
        return 30.0f;
    }
}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    return [UIColor clearColor];
}

- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column {
    return [UIColor lightGrayColor];
}

////////////////////////////////////// ????
- (NSString *)vertexName {
    //return @"Vertex";
    return @"";
}

#pragma mark - XCMultiTableViewDelegate

- (void)tableViewWithType:(MultiTableViewType)tableViewType didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableViewType:%@, selectedIndexPath: %@", @(tableViewType), indexPath);
    
    //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.showTabel];
    
    //indexPath = [self.showTabel indexPathForRowAtPoint:buttonPosition];
}

- (void)getRequestData {
    
    self.loader = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    self.loader.labelText = @"Please wait a moment...";
    self.loader.labelFont = [UIFont fontWithName:@"Bariol-Bold" size:[UIFont systemFontSize]];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [[manager HTTPRequestOperationWithRequest:[getData searchRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponseError = [responseObject objectForKey:@"err"];
        if ([strResponseError isKindOfClass:[NSNull class]]) {
            // init data
            // init _Schedule_Dic
            if (ScheduleData == nil) {
                ScheduleData = [[NSMutableDictionary alloc]init];
                dateDict = [[NSMutableDictionary alloc]init];
                orderedKeys = [[NSMutableArray alloc]init];
 
            }else{
                [ScheduleData removeAllObjects];
                ScheduleData = nil;
                ScheduleData = [[NSMutableDictionary alloc]init];
              
                [dateDict removeAllObjects];
                dateDict = nil;
                dateDict = [[NSMutableDictionary alloc]init];
                
                [orderedKeys removeAllObjects];
                orderedKeys = nil;
                orderedKeys = [[NSMutableArray alloc]init];
 
            }
            
            ScheduleDataArry = [[responseObject objectForKey:@"data"] mutableCopy];
            NSString *strID;
            for(NSDictionary *r in ScheduleDataArry) {
                strID = [r objectForKey:@"id"];
                [ScheduleData setObject:r forKey:strID];
                [dateDict setObject:strID forKey:[r objectForKey:@"schedule_date"]];
            }
            [self sortContacts];
            [self initData];
            [tableViewObj reloadData];
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:ScheduleData forKey:@"ScheduleData"];
        }
        [self.loader hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        //NSString *strError = [[NSString init]initWithFormat:@"%@", error];
        //UIAlertView to let them know that something happened with the network connection...
        [self show_toast:@"connection error"];
        [self.loader hide:YES];
    }] start];
}
-(void)show_toast:(NSString *)message{
    //diplay message--------------
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    toast.backgroundColor=[UIColor redColor];
    [toast show];
    int duration = 2; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{                [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
    //----------------------------
}

-(void)sortContacts{
    
    orderedKeys = [[ScheduleData allKeys] mutableCopy];
    orderedKeys = [[orderedKeys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSNumericSearch];
    }]mutableCopy];
    

//    orderedDateKeys = [[dateDict allKeys] mutableCopy];
//    orderedDateKeys = [[orderedDateKeys sortedArrayUsingComparator:^(id a, id b) {
//        return [a compare:b options:NSNumericSearch];
//    }]mutableCopy];
    
}
-(void)show_TableView{
    [self initTable];
    tableViewObj = [[XCMultiTableView alloc] initWithFrame:CGRectInset(self.scheduleSubView.bounds, 2.0f, 2.0f)];
    tableViewObj.leftHeaderEnable = YES;
    tableViewObj.datasource = self;
    tableViewObj.delegate = self;
    [self.scheduleSubView addSubview:tableViewObj];

}
- (IBAction)onreload:(id)sender {
    [self getRequestData];
}

@end
