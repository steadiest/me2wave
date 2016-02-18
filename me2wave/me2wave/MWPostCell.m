//
//  MWPostCell.m
//  me2wave
//
//  Created by kgn on 12. 11. 3..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import "MWPostCell.h"

#import "NSString+Me2TextStripper.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation MWPostCell

@synthesize details, comments, commenters;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    comments = [[NSMutableArray alloc] init];
    commenters = [[NSMutableArray alloc] init];
    if (self) {
        message = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 50)];
        message.font = [UIFont systemFontOfSize:15];
        [message setLineBreakMode:NSLineBreakByWordWrapping];
        [message setNumberOfLines:3];
        
        for(int i = 0; i < 5; i++) {
            
            UIImageView *commenter = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 + i * 40, 30, 30)];
            UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(50, 60 + 40 * i, 265, 40)];
            comment.font = [UIFont systemFontOfSize:12];
            [comment setLineBreakMode:NSLineBreakByWordWrapping];
            [comment setNumberOfLines:3];
            
            [comments addObject:comment];
            [commenters addObject:commenter];
            
            [self addSubview:comment];
            [self addSubview:commenter];
            
            [comment release];
            [commenter release];
        }
        
        [self addSubview:message];
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

- (void)decorate {
    
    message.text = [[[details.post objectForKey:@"message"] objectForKey:@"text"] removeLinkExpressions];
    
    int count = MIN([details.comments count], 5);
    for (int i = 0; i < count; i++) {
        
        [[commenters objectAtIndex:i] setHidden:NO];
        [[comments objectAtIndex:i] setHidden:NO];
        id comment = [details.comments objectAtIndex:i];
        UIImageView *commenter = [commenters objectAtIndex:i];
        [commenter setImageWithURL:[NSURL URLWithString:[[comment objectForKey:@"author"] objectForKey:@"profile"]]];
        UILabel *commentMessage = [comments objectAtIndex:i];
        commentMessage.text = [[[comment objectForKey:@"message"] objectForKey:@"text"] removeLinkExpressions];
    }
    
    for(int i = 4; i >= count; i--) {
        [[commenters objectAtIndex:i] setHidden:YES];
        [[comments objectAtIndex:i] setHidden:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
    
//    [metoos release];
//    [comments release];
//    [commenters release];
}

@end
