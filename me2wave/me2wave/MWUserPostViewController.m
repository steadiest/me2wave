//
//  MWUserPostViewController.m
//  me2wave
//
//  Created by kgn on 12. 11. 3..
//  Copyright (c) 2012년 kgn. All rights reserved.
//

#import "MWUserPostViewController.h"

#import "MWMe2dayClient.h"
#import "MWPostDetails.h"
#import "MWPostCell.h"

@interface MWUserPostViewController ()

@end

@implementation MWUserPostViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUserId:(NSString*)userId {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        postDetails = [[NSMutableArray alloc] init];
        [self performSelectorInBackground:@selector(load:) withObject:userId];
        
    }
    return self;
}

- (void)load:(NSString*)userId {
    
    id postsMetoosAndComments = [MWMe2dayClient getPostsMetoosAndComments:userId];
    
    id posts = [[postsMetoosAndComments objectForKey:@"posts"] objectForKey:@"objects"];
    
    int count = [posts count];
    
    for(int i = 0; i < count; i++) {
        
        MWPostDetails *details = [[MWPostDetails alloc] init];
        details.post = [posts objectAtIndex:i];
        details.comments = [[postsMetoosAndComments objectForKey:[NSString stringWithFormat:@"comments%d", i]] objectForKey:@"objects"];
        
        [postDetails addObject:details];
        [details release];
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [postDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    MWPostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MWPostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.details = [postDetails objectAtIndex:[indexPath row]];
    
    [cell decorate];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MWPostDetails *details = [postDetails objectAtIndex:[indexPath row]];
    
    return 60 + MIN([details.comments count], 5) * 40;
}


@end
