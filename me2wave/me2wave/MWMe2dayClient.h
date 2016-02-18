//
//  MWMe2dayClient.h
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* kApplicationKeyForV1 = @"7cc4516251d2ede6a43842b31397dbd4";
static NSString* kApplicationKeyForV2 = @"c44b131ec1c34d48d36ec90d6b51ff2f";
static NSString* kGetAccessTokenViaFullAuthTokenURL = @"https://api.me2day.net/oauth2/token.issue?client_id=%@&grant_type=full_auth_token&me2_application_key=%@&user_id=%@&full_auth_token=%@";

@interface MWMe2dayClient : NSObject

+ (void)getAuthenticationUrl:(NSString**)authUrl token:(NSString**)authToken;
+ (void)saveAccessTokenByFullAuthToken:(NSString*)token;

+ (NSArray*)getFriends:(NSString*)userId;
+ (id)getFriendsAndPosts:(NSString*)userId;
+ (id)getPostsAndFriends:(NSArray*)userIds;
+ (id)getPostsMetoosAndComments:(NSString*)userId;

@end
