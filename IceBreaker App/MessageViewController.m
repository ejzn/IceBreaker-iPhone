//
//  MessageViewController.m
//  IceBreaker
//
//  Created by Erik Johnson on 2013-11-07.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize messages, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *clientsURL = @"http://dev.erikjohnson.ca:8001/client/message/list";
    ServerAPI *serverAPI = [[ServerAPI alloc] initMessageDelegate:self];
    [serverAPI getMessages:clientsURL];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)messagesComplete: (ServerAPI*) messagesList
{
    NSLog(@"Got messages of success");
    self.messages = [messagesList valueForKey:@"messages"];
    NSLog(@"Messages List: %@",self.messages);
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *rowObj = [self.messages objectAtIndex:indexPath.row];
    NSMutableString *lineString = [[NSMutableString alloc]initWithString: [rowObj valueForKey:@"dest_phone"]];
    
    // Configure the cell.
    cell.textLabel.text = lineString;
    UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 33)];
    headline.text = [rowObj valueForKey:@"text"];
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


@end
