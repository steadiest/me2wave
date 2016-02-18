//
//  NSString+Me2TextStripper.m
//  me2wave
//
//  Created by kgn on 12. 11. 3..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import "NSString+Me2TextStripper.h"

@implementation NSString (Me2TextStripper)

- (NSString*) removeLinkExpressions {
    
    BOOL startName = NO, endName = NO, startUrl = NO, endUrl = NO;
    NSMutableString *refined = [[NSMutableString alloc] initWithCapacity:[self length]];
    for (int i = 0; i < [self length]; i++) {
        unichar current = [self characterAtIndex:i];
        
        if (current == '"') {
            if (startName) {
                endName = YES;
            } else {
                startName = YES;
            }
        } else if (current == ':') {
            if (endName) {
                startUrl = YES;
            }
        } else if (current == ' ') {
            endUrl = YES;
            startName = NO;
            endName = NO;
            startUrl = NO;
            [refined appendString:@" "];
        } else if (!startUrl) {
            [refined appendString:[NSString stringWithCharacters:&current length:1]];
        }
    }
    
    return [refined autorelease];
}
@end
