//
//  MWUserPostViewController.h
//  me2wave
//
//  Created by kgn on 12. 11. 3..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWUserPostViewController : UITableViewController {
    
    NSMutableArray *postDetails;
}

- (id)initWithUserId:(NSString*)userId;
@end
