//
//  knockrAPI.h
//  IceBreaker
//
//  Created by Erik Johnson on 2013-11-03.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIAuthentication.h"

#import <CoreLocation/CoreLocation.h>

@class ServerAPI;

@protocol ServerAPIDelegate

-(void)userListComplete:(NSDictionary *) users;
-(void)messagesComplete:(NSDictionary *) messages;

@end

@interface ServerAPI : NSObject

// define delegate property
@property (nonatomic, assign) id <ServerAPIDelegate> _usersDelegate, _messagesDelegate;

- (id)initUserDelegate:(id<ServerAPIDelegate>) delegate;
- (id)initMessageDelegate:(id<ServerAPIDelegate>) delegate;

- (void)getUsersList:(NSString*)url;
- (void)getMessages:(NSString*)url;
- (void)registerClient:(LIAuthentication*) auth;
- (void)clientActivity:(CLLocation*) location;

@end

