//
//  ExploreViewController.h
//  IceBreaker
//
//  Created by Erik Johnson on 2013-11-02.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerAPI.h"

@interface ExploreViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource, ServerAPIDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *nearbyClients;

@end
