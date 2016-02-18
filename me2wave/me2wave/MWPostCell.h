//
//  MWPostCell.h
//  me2wave
//
//  Created by kgn on 12. 11. 3..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MWPostDetails.h"

@interface MWPostCell : UITableViewCell {
    
    MWPostDetails *details;
    UILabel *message;
    NSMutableArray *commenters;
    NSMutableArray *comments;
}

@property(nonatomic, retain) MWPostDetails* details;
@property(nonatomic, retain) NSMutableArray *commenters;
@property(nonatomic, retain) NSMutableArray *comments;

- (void)decorate;

@end
