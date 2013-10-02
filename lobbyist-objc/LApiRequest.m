//
//  LApiRequest.m
//  lobbyist-objc
//
//  Created by David Lains on 9/29/13.
//  Copyright (c) 2013 Customer Lobby. All rights reserved.
//

#import "LApiRequest.h"

@interface LApiRequest ()

-(NSString*)authorizationData;

@end

@implementation LApiRequest

+(id)requestWithURL:(NSURL*)url method:(NSString*)method formParameters:(NSDictionary*)params
{
    return [[self alloc] initWithURL:url method:method formParameters:params];
}

-(id)initWithURL:(NSURL*)url method:(NSString*)method formParameters:(NSDictionary*)params
{
    if ((self = [super initWithURL:url]))
    {
        [self setHTTPMethod:method];
        [self setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        [self setValue:[self authorizationData] forHTTPHeaderField:@"Authorization"];
        [self setHTTPBody:];
    }
    return self;
}

-(void)setFormParameters:(NSDictionary*)params
{
    
}

-(NSString*)authorizationData
{
    NSMutableString* data = [[NSMutableString alloc] init];
    [data appendString:@"Token:"];
    
}

@end
