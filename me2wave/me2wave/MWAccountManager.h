//
//  MWAccountManager.h
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWAccountManager : NSObject

+ (NSString*)getUserId;
+ (NSString*)getAccessToken;
+ (void)setAccessToken:(NSString*)accessToken forUserId:(NSString*)userId;
+ (void)deleteAccounts;

@end
