//
//  MWAccountManager.m
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import "MWAccountManager.h"

@implementation MWAccountManager

+ (NSString*)getUserId {
    
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    return [defaults stringForKey:@"userId"];
}

+ (NSString*)getAccessToken {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults stringForKey:@"accessToken"];
}

+ (void)setAccessToken:(NSString*)accessToken forUserId:(NSString*)userId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults setValue:accessToken forKey:@"accessToken"];
    [defaults setValue:userId forKey:@"userId"];
    
	[defaults synchronize];
}

+ (void)deleteAccounts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setValue:nil forKey:@"accessToken"];
    [defaults setValue:nil forKey:@"userId"];
    
	[defaults synchronize];
}

@end
