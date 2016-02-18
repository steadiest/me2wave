//
//  MWViewController.m
//  me2wave
//
//  Created by kgn on 12. 11. 2..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MWViewController.h"
#import "MWAccountManager.h"
#import "MWLoginViewController.h"
#import "MWUserPostViewController.h"
#import "MWMe2dayClient.h"
#import "MWFriendDetails.h"
#import "MWFriendCell.h"

#import "NSString+Me2TextStripper.h"

static int kProfileImageButtonTag = 1997;
static int kFirstPostLabelTag = 1998;
static int kSecondPostLabelTag = 1999;
static int kThirdPostLabelTag = 2000;
static int kNicknameLabelTag = 2001;

@interface MWViewController ()

- (void)popToParentView;
- (void)popToRootView;
- (void)logout;

- (void)load:(NSString*)userId;
@end

@implementation MWViewController

- (void)dealloc {
    
    [super dealloc];
    [friendDetails release];
}

- (id)initWithUserId:(NSString*)userId {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        if (userId != nil) {
            [self performSelectorInBackground:@selector(load:) withObject:userId];
        }
        
    }
    return self;
}

- (id)initWithFriends:(NSArray*)friends {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        [self performSelectorInBackground:@selector(loadWithFriends:) withObject:friends];
        
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        currentUserId = [MWAccountManager getUserId];
        if (currentUserId != nil) {
            [self performSelectorInBackground:@selector(load:) withObject:currentUserId];
        }
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadWithFriends:(NSArray*)friends {
    
    id postsAndFriends = [MWMe2dayClient getPostsAndFriends:friends];
    int count = [friends count];
    
    if (friendDetails) {
        [friendDetails release];
        friendDetails = nil;
    }
    
    friendDetails = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < count; i++) {
        MWFriendDetails *details = [[MWFriendDetails alloc] init];
        
        id posts = [[postsAndFriends objectForKey:[NSString stringWithFormat:@"posts%d", i]] objectForKey:@"objects"];
        id authorsFriends = [[postsAndFriends objectForKey:[NSString stringWithFormat:@"friends%d", i]] objectForKey:@"objects"];
        
        details.profile = [friends objectAtIndex:i];
        details.posts = posts;
        details.friends = authorsFriends;
        
        [friendDetails addObject:details];
        [details release];
    }
    
    NSLog(@"Try to reload");
    [self.tableView reloadData];}

- (void)load:(NSString*)userId {
    
    NSLog(@"Loading posts of %@", userId);
    
    id friends = [MWMe2dayClient getFriends:userId];
    [self loadWithFriends:friends];
}

- (void)viewDidAppear:(BOOL)animated {
    // this is root view
    [self leadToLoginIfRequired];
}

- (void)leadToLoginIfRequired {
    NSString *userId = [MWAccountManager getUserId];
    if (userId == nil) {
        // show login view
        MWLoginViewController *controller = [[MWLoginViewController alloc] init];
        [self.navigationController presentViewController:controller animated:NO completion:nil];
        [controller login];
        [controller release];
    } else if ([self.navigationController.viewControllers count] == 1) {
        if ([friendDetails count] == 0) {
            [self load:userId];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logout;
    [logout release];

    if ([self.navigationController.viewControllers count] != 1) {
        // put back & top button
        UIBarButtonItem *root = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItem)107 target:self action:@selector(popToRootView)];
        UIBarButtonItem *parent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItem)101 target:self action:@selector(popToParentView)];
        NSArray *items = [[NSArray alloc] initWithObjects:parent, root, nil];
        
        self.navigationItem.rightBarButtonItems = items;
        [items release];
        [root release];
        [parent release];
    }
}

- (void)logout {
    currentUserId = nil;
    [MWAccountManager deleteAccounts];
    [self leadToLoginIfRequired];
}

- (void)popToParentView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [friendDetails count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    MWFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MWFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setFrame:CGRectMake(0, 0, 320, 80)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 70, 70)];
        imageView.tag = kProfileImageButtonTag;
        [cell addSubview:imageView];
        
        UILabel *nickname = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, 70, 15)];
        nickname.tag = kNicknameLabelTag;
        nickname.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:nickname];
        [nickname release];
        
        UILabel *firstPost = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 30)];
        UILabel *secondPost = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 30)];
        UILabel *thirdPost = [[UILabel alloc] initWithFrame:CGRectMake(80, 75, 200, 30)];
        
        firstPost.font = [UIFont systemFontOfSize:12];
        secondPost.font = [UIFont systemFontOfSize:12];
        thirdPost.font = [UIFont systemFontOfSize:12];
        
        [firstPost setLineBreakMode:NSLineBreakByWordWrapping];
        [firstPost setNumberOfLines:2];
        [secondPost setLineBreakMode:NSLineBreakByWordWrapping];
        [secondPost setNumberOfLines:2];
        [thirdPost setLineBreakMode:NSLineBreakByWordWrapping];
        [thirdPost setNumberOfLines:2];
        
        firstPost.tag = kFirstPostLabelTag;
        secondPost.tag = kSecondPostLabelTag;
        thirdPost.tag = kThirdPostLabelTag;
        
        [cell addSubview:firstPost];
        [cell addSubview:secondPost];
        [cell addSubview:thirdPost];
        
        [firstPost release];
        [secondPost release];
        [thirdPost release];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    // Configure the cell...
    cell.details = [friendDetails objectAtIndex:[indexPath row]];
    
    NSString* profile = [cell.details.profile objectForKey:@"profile"];
    
    [((UIImageView*)[cell viewWithTag:kProfileImageButtonTag]) setImageWithURL:[NSURL URLWithString:profile]];
    
    ((UILabel*)[cell viewWithTag:kNicknameLabelTag]).text = [cell.details.profile objectForKey:@"nickname"];
    
    int postCount = [cell.details.posts count];
    NSString *firstPostMessage = nil, *secondPostMessage = nil, *thirdPostMessage = nil;
    if (postCount > 0) {
        firstPostMessage = [[[cell.details.posts objectAtIndex:0] objectForKey:@"message"] objectForKey:@"text"];
    }
    if (postCount > 1) {
        secondPostMessage = [[[cell.details.posts objectAtIndex:1] objectForKey:@"message"] objectForKey:@"text"];
    }
    if (postCount > 2) {
        thirdPostMessage = [[[cell.details.posts objectAtIndex:2] objectForKey:@"message"] objectForKey:@"text"];
    }
    
    ((UILabel*)[cell viewWithTag:kFirstPostLabelTag]).text = [firstPostMessage removeLinkExpressions];
    ((UILabel*)[cell viewWithTag:kSecondPostLabelTag]).text = [secondPostMessage removeLinkExpressions];
    ((UILabel*)[cell viewWithTag:kThirdPostLabelTag]).text = [thirdPostMessage removeLinkExpressions];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    MWFriendCell *cell = (MWFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    MWViewController *controller = [[MWViewController alloc] initWithFriends:cell.details.friends];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MWFriendCell *cell = (MWFriendCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString* userId = [cell.details.profile objectForKey:@"id"];
    MWUserPostViewController *controller = [[MWUserPostViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
