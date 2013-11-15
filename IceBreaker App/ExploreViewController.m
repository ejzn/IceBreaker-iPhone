//
//  ExploreViewController.m
//  IceBreaker
//
//  Created by Erik Johnson on 2013-11-02.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "ExploreViewController.h"
#import "ServerAPI.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

@synthesize nearbyClients, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) userListComplete: (ServerAPI*) users {
    NSLog(@"Got messages of success");
    self.nearbyClients = [users valueForKey:@"clients"];
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *clientsURL = @"http://dev.erikjohnson.ca:8001/client/list";
    ServerAPI *serverAPI = [[ServerAPI alloc] initUserDelegate:self];
    [serverAPI getUsersList: clientsURL];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nearbyClients count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *rowObj = [self.nearbyClients objectAtIndex:indexPath.row];
    NSMutableString *lineString = [[NSMutableString alloc]initWithString: [rowObj valueForKey:@"firstname"]];
    [lineString appendString:(@" ")];
    [lineString appendString:[rowObj valueForKey:@"lastname"]];
    
    // Configure the cell.
    cell.textLabel.text = lineString;
    UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 33)];
    headline.text = [rowObj valueForKey:@"headline"];
    UIFont *myFont = [UIFont fontWithName: @"Georgia" size: 10.0 ];
    headline.font = myFont;
    
    [cell.textLabel addSubview: headline];
    myFont = [UIFont fontWithName: @"Arial-BoldMT" size: 12.0 ];
    cell.textLabel.font = myFont;
    
    NSLog(@"Line String: %@",lineString);
    
    
    NSString *ImageURL = [rowObj valueForKey:@"image_url"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    cell.imageView.image = [UIImage imageWithData:imageData];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
