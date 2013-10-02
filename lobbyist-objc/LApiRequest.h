//
//  LApiRequest.h
//  lobbyist-objc
//
//  Created by David Lains on 9/29/13.
//  Copyright (c) 2013 Customer Lobby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LApiRequest : NSMutableURLRequest {}

+(id)requestWithURL:(NSURL*)url method:(NSString*)method formParameters:(NSDictionary*)params;
-(id)initWithURL:(NSURL*)url method:(NSString*)method formParameters:(NSDictionary*)params;

-(void)setFormParameters:(NSDictionary*)params;

@end
