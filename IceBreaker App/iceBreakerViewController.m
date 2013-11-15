//
//  ntwrkrViewController.m
//  Networking App
//
//  Created by Erik Johnson on 2013-10-15.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "iceBreakerViewController.h"

@interface iceBreakerViewController ()

@end

@implementation iceBreakerViewController

    @synthesize buttonSignIn, locationManager, serverAPI;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"li-auth_token"] && [defaults objectForKey:@"li-token_expiry"]) {
        [self loggedIn];
        
    } else {
        [buttonSignIn addTarget:self action:NSSelectorFromString(@"signIn") forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)signIn {
    [[LISignIn sharedInstance]setDelegate:self];
    [[LISignIn sharedInstance]authenticateFrom:self];
}

-(void)notLoggedIn {
    NSLog(@"Not Logged In");
}

-(void)loggedIn {
    
    [self performSegueWithIdentifier: @"LinkedSeque" sender: self];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
     serverAPI = [ServerAPI alloc];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults objectForKey:@"phone_id"]) {
        // Let's get a phone id into our database...
        [serverAPI registerClient: [LISignIn sharedInstance].auth];
    }
    
     NSLog(@"Client Id: %@", [defaults objectForKey:@"phone_id"]);
    
    [self performSegueWithIdentifier: @"LinkedSeque" sender: self];
    NSLog(@"Logged in...");
    
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"phone_id"]) {
        // Once we have a stored phone_id let's send our location, then stop checking location...
        [serverAPI clientActivity: newLocation];
        [locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError*)error{
    if( [(NSString *)[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"] ){
        
        NSLog(@"Simulator manually setting the location of the device.");
        CLLocation *newLocation  = [[CLLocation alloc] initWithLatitude:50.6246 longitude:-2.235235];
        [serverAPI clientActivity: newLocation];
        [locationManager stopUpdatingLocation];
        return;
    }
    [locationManager stopUpdatingLocation];
}


-(void)loggedInError {
    NSLog(@"Sign in error");
}

#pragma mark LISignInDelegate protocol

- (void)finishedLIAuthentificationWithError:(NSError *)error {
    if (error==nil) {
        [self loggedIn];
    } else {
        [self loggedInError];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
