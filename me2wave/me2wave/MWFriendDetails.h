//
//  MWFriendDetails.h
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWFriendDetails : NSObject {
    
    id profile;
    NSArray *posts;
    NSArray *friends;
}

@property (nonatomic, retain) id profile;
@property (nonatomic, retain) NSArray *posts;
@property (nonatomic, retain) NSArray *friends;

@end
