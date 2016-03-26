//
//  SavedShowCellViewController.h
//  RadioStream
//
//  Created by dev on 3/17/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ViewController.h"

@interface SavedShowCellViewController : ViewController

@property (strong, nonatomic) UILocalNotification *oNotification;
@property (strong, nonatomic) IBOutlet UILabel *scheduleTitle;
@property (strong, nonatomic) IBOutlet UILabel *scheduleDate;
@property (strong, nonatomic) IBOutlet UILabel *scheduleTime;
@property (strong, nonatomic) IBOutlet UIImageView *s_image;
@property (strong, nonatomic) IBOutlet UITextView *scheduleMore;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *picloader;


@end
