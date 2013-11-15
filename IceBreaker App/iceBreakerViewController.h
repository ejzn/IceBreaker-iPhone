//
//  ntwrkrViewController.h
//  Networking App
//
//  Created by Erik Johnson on 2013-10-15.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LISignIn.h"
#import "ServerAPI.h"
#import <CoreLocation/CoreLocation.h>


@interface iceBreakerViewController : UIViewController
        <CLLocationManagerDelegate>

@property (nonatomic, retain) IBOutlet UIButton* buttonSignIn;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) ServerAPI *serverAPI;
@property (strong, nonatomic) NSUserDefaults *defaults;

-(void)signIn;

@end
