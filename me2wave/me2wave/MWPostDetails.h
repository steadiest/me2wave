//
//  MWPostDetails.h
//  me2wave
//
//  Created by kgn on 12. 11. 3..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWPostDetails : NSObject {
    
    id post;
    NSArray *comments;
}

@property(nonatomic, retain) id post;
@property(nonatomic, retain) NSArray *comments;

@end
