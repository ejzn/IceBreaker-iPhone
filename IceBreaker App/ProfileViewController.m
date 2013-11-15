//
//  ProfileViewController.m
//  IceBreaker
//
//  Created by Erik Johnson on 2013-11-02.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize name, profilePicture, status, headline;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) userInfoRetrieved
{
    [self populateControl];
}

- (void) populateControl
{
    NSMutableString *nameString = [[NSMutableString alloc]initWithString: [LISignIn sharedInstance].auth.userFirstName];
    [nameString appendString:(@" ")];
    [nameString appendString: [LISignIn sharedInstance].auth.userLastName];
    
    name.text = nameString;
    headline.text =[LISignIn sharedInstance].auth.headline;
    
    NSString *ImageURL = [LISignIn sharedInstance].auth.userPictureUrl;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    profilePicture.image = [UIImage imageWithData:imageData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([LISignIn sharedInstance].auth != NULL && [LISignIn sharedInstance].auth.userFirstName != NULL){
        [self populateControl];
        
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"li-auth_token"] && [defaults objectForKey:@"li-token_expiry"]) {
            
            LIAuthentication* authO = [LIAuthentication authenticationWithToken:[defaults objectForKey:@"li-auth_token"]];
            [authO initUserDelegate:self];
            [authO fetchUserInfos];
            [[LISignIn sharedInstance]setAuth:authO];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
