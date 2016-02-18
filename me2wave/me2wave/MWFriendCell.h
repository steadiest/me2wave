//
//  MWFriendCell.h
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFriendDetails.h"

@interface MWFriendCell : UITableViewCell {
    
    MWFriendDetails *details;
}

@property (nonatomic, retain) MWFriendDetails* details;

@end
