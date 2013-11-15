//
//  ProfileViewController.h
//  IceBreaker
//
//  Created by Erik Johnson on 2013-11-02.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LISignIn.h"

@interface ProfileViewController : UIViewController
    <UserInfoDelegate>
@property (nonatomic, retain) IBOutlet UILabel* name;
@property (nonatomic, retain) IBOutlet UILabel* status;
@property (nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic, retain) IBOutlet UILabel* headline;
@end
