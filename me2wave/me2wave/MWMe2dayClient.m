//
//  MWMe2dayClient.m
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import "MWMe2dayClient.h"
#import "MWAccountManager.h"
#import "JSON.h"

#import "MD5Context.h"
#import "NSData+Extensions.h"

#import "OrderedDictionary.h"

@interface MWMe2dayClient ()

@end

@implementation MWMe2dayClient

+ (void)getAuthenticationUrl:(NSString**)authUrl token:(NSString**)authToken {
	
	NSURL *url = [[NSURL alloc] initWithString:@"http://me2day.net/api/get_auth_url.json"];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
    [request addValue:kApplicationKeyForV1 forHTTPHeaderField:@"me2_application_key"];
    
	NSURLResponse *response;
	NSError *error;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSLog(@"response code : %d", [(NSHTTPURLResponse*)response statusCode]);
	
	NSString *responseAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	id responseAsJson = [responseAsString JSONValue];
	
	[url release];
	[responseAsString release];

	*authUrl = [responseAsJson objectForKey:@"url"];
    *authToken = [[responseAsJson objectForKey:@"token"] retain];
}

+ (void)saveAccessTokenByFullAuthToken:(NSString*)token {
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://me2day.net/api/get_full_auth_token.json?token=%@", token];
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	[urlString release];
    
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
    [request addValue:kApplicationKeyForV1 forHTTPHeaderField:@"me2_application_key"];
	
	NSURLResponse *response;
	NSError *error;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSLog(@"response code : %d", [(NSHTTPURLResponse*)response statusCode]);
	
	NSString *responseAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"response string : %@", responseAsString);
	id responseAsJson = [responseAsString JSONValue];
	
    NSString *userId = [responseAsJson objectForKey:@"user_id"];
    NSString *authToken = [responseAsJson objectForKey:@"auth_token"];
    
	[responseAsString release];
	[url release];
	[request release];
	
    NSString *urlForIssuingAccessToken = [[NSString alloc] initWithFormat:kGetAccessTokenViaFullAuthTokenURL, kApplicationKeyForV2, kApplicationKeyForV1, userId, authToken];
    
    NSURLRequest *issueAccessToken = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlForIssuingAccessToken]];
    
    data = [NSURLConnection sendSynchronousRequest:issueAccessToken returningResponse:&response error:&error];

    NSLog(@"response code : %d", [(NSHTTPURLResponse*)response statusCode]);
	
	responseAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	responseAsJson = [responseAsString JSONValue];
    
    NSString *accessToken = [responseAsJson objectForKey:@"access_token"];
    
    NSLog(@"Access token : %@, %@ %@", accessToken, responseAsString, authToken);
    [responseAsString release];
    
    [MWAccountManager setAccessToken:accessToken forUserId:userId];
    [urlForIssuingAccessToken release];
}

+ (NSArray*)getFriends:(NSString*)userId {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* url = [NSString stringWithFormat:@"https://api.me2day.net/users/%@/friends/intimate?access_token=%@&paging.count=10", userId, [MWAccountManager getAccessToken]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
	NSURLResponse *response;
	NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* responseAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    id responseAsJson = [responseAsString JSONValue];
    [responseAsString release];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return [responseAsJson objectForKey:@"objects"];
}


+ (id)getPostsAndFriends:(NSArray*)users {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *parametersForFriends = [[NSDictionary alloc] initWithObjectsAndKeys:@"10", @"paging.count", nil];

    NSDictionary *parametersForPosts = [[NSDictionary alloc] initWithObjectsAndKeys:@"3", @"paging.count", nil];

    OrderedDictionary *message = [[OrderedDictionary alloc] initWithCapacity:20];
    int count = 0;
    for (id user in users) {
        
        NSString *userId = [user objectForKey:@"id"];
        
        NSString *urlForPosts = [NSString stringWithFormat:@"/users/%@/posts", userId];
        NSDictionary *posts = [[NSDictionary alloc] initWithObjectsAndKeys:urlForPosts, @"url", parametersForPosts, @"parameters", nil];
        
        NSString *urlForFriends = [NSString stringWithFormat:@"/users/%@/friends/intimate", userId];
        NSDictionary *friends = [[NSDictionary alloc] initWithObjectsAndKeys:urlForFriends, @"url", parametersForFriends, @"parameters", nil];
        [message setObject:posts forKey:[NSString stringWithFormat:@"posts%d", count]];
        [message setObject:friends forKey:[NSString stringWithFormat:@"friends%d", count]];
        count++;
        
        [posts release];
        [friends release];
    }
    
    NSString* url = [NSString stringWithFormat:@"https://api.me2day.net/link?link_mode=concurrent&access_token=%@&link.messages=%@", [MWAccountManager getAccessToken], [[message JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
	NSURLResponse *response;
	NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* responseAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    id responseAsJson = [responseAsString JSONValue];
    [responseAsString release];
    
    [parametersForFriends release];
    [parametersForPosts release];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return responseAsJson;
}

+ (id)getPostsMetoosAndComments:(NSString*)userId {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSDictionary *parametersForComments = [[NSDictionary alloc] initWithObjectsAndKeys:@"10", @"paging.count", nil];
    NSDictionary *parametersForPosts = [[NSDictionary alloc] initWithObjectsAndKeys:@"5", @"paging.count", nil];
    
    OrderedDictionary *message = [[OrderedDictionary alloc] initWithCapacity:20];
    NSString *urlForPosts = [NSString stringWithFormat:@"/users/%@/posts", userId];
    NSDictionary *posts = [[NSDictionary alloc] initWithObjectsAndKeys:urlForPosts, @"url", parametersForPosts, @"parameters", nil];
    [message setObject:posts forKey:@"posts"];
    
    for (int i = 0; i < 5; i++) {
        NSString *urlForComments = [NSString stringWithFormat:@"/posts/@posts[%d].id/comments", i];
        NSDictionary *comments = [[NSDictionary alloc] initWithObjectsAndKeys:urlForComments, @"url", parametersForComments, @"parameters", nil];
        [message setObject:comments forKey:[NSString stringWithFormat:@"comments%d", i]];
        
        
        [comments release];
    }
    
    [posts release];
    
    NSString* url = [NSString stringWithFormat:@"https://api.me2day.net/link?access_token=%@&link.messages=%@", [MWAccountManager getAccessToken], [[message JSONRepresentation] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
	NSURLResponse *response;
	NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* responseAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    id responseAsJson = [responseAsString JSONValue];
    [responseAsString release];
    
    [parametersForComments release];
    [parametersForPosts release];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return responseAsJson;
}

@end
