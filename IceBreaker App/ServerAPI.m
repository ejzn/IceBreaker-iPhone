//
//  knockrAPI.m
//  IceBreaker
//
//  Created by Erik Johnson on 2013-11-03.
//  Copyright (c) 2013 Erik Johnson. All rights reserved.
//

#import "ServerAPI.h"

@implementation ServerAPI

@synthesize _usersDelegate, _messagesDelegate;

-(id)initUserDelegate:(id<ServerAPIDelegate>)delegate {
    
    self = [super init];
    if(self) {
        _usersDelegate = delegate;
    }
    return self;
    
}

-(id)initMessageDelegate:(id<ServerAPIDelegate>)delegate {
    
    self = [super init];
    if(self) {
        _messagesDelegate = delegate;
    }
    return self;
    
}

-(void)clientActivity: (CLLocation*) location {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* postString = [NSString stringWithFormat:@"api_token=%@&latitude=%f&longitude=%f", [defaults objectForKey:@"api_token"],  location.coordinate.latitude, location.coordinate.longitude];
    
    NSMutableString* url = [[NSMutableString alloc]initWithString: @"http://dev.erikjohnson.ca:8001/client/activity/"];
    [url appendString: [defaults objectForKey:@"phone_id"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", data.length] forHTTPHeaderField:@"Content-Length"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        if (error) {
            // Do something in error
            return;
        }
        
        NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        if (responseString.length > 0) {
            NSError* jsonError = nil;
            NSDictionary* receivedJson = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
            NSString* code = [receivedJson valueForKey:@"code" ];
            
            if (jsonError!=nil || code.intValue !=1 ) {
                // Some kind of JSON error here
                NSLog(@"Error from API. or parsing JSON");
            } else {
                // we passes
            }
        }
        
    });
    
}



-(void)registerClient: (LIAuthentication*) auth {
    NSString* postString = [NSString stringWithFormat:@"firstname=%@&lastname=%@&image_url=%@&headline=%@", auth.userFirstName, auth.userLastName, auth.userPictureUrl, auth.headline];
    NSString* url = @"http://dev.erikjohnson.ca:8001/client/register";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", data.length] forHTTPHeaderField:@"Content-Length"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        if (error) {
            // Do something in error
            return;
        }
        
        NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        if (responseString.length > 0) {
            NSError* jsonError = nil;
            NSDictionary* receivedJson = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
            
            NSDictionary* result = [receivedJson valueForKey:@"client"];
            NSString* phoneId = [result valueForKey:@"id" ];
            
            if (jsonError!=nil) {
                // Some kind of JSON error here
                NSLog(@"Error parsing JSON");
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:phoneId forKey:@"phone_id"];
            }
        }
        
    });

}

-(void)getUsersList:(NSString*)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] ;
    request.HTTPMethod=@"GET";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        if (error) {
            // Do something in error
            return;
        }
        
        NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        if (responseString.length > 0) {
            NSError* jsonError = nil;
            NSDictionary* receivedJson = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
            
            if (jsonError!=nil) {
                // Some kind of JSON error here
                NSLog(@"Error parsing JSON");
            } else {
                NSLog(@"Got success response.");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Sending dispatch that request is done.");
                    [self._usersDelegate userListComplete: receivedJson];
                });
            }
        }
        
    });
}


-(void)getMessages:(NSString*)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] ;
    request.HTTPMethod=@"GET";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        if (error) {
            // Do something in error
            return;
        }
        
        NSString *responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        if (responseString.length > 0) {
            NSError* jsonError = nil;
            NSDictionary* receivedJson = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
            
            if (jsonError!=nil) {
                // Some kind of JSON error here
                NSLog(@"Error parsing JSON");
            } else {
                NSLog(@"Got success response.");
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Sending dispatch that request is done.");
                    [self._messagesDelegate messagesComplete: receivedJson];
                });
            }
        }
        
    });
}


@end
