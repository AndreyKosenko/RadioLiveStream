//
//  SavedShowViewController.h
//  RadioStream
//
//  Created by dev on 3/9/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ViewController.h"

@interface SavedShowViewController : ViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *showTabel;

@end
