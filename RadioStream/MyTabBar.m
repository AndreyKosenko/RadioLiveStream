//
//  MyTabBar.m
//  RadioStream
//
//  Created by dev on 3/7/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "MyTabBar.h"

@implementation MyTabBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 63;
    
    return sizeThatFits;
}

@end
