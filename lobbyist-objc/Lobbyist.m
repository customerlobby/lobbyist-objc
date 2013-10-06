//
//  Lobbyist.m
//  Lobbyist
//
//  Created by David Lains on 9/26/13.
//  Copyright (c) 2013 Customer Lobby. All rights reserved.
//

#import "Lobbyist.h"

@implementation Lobbyist

@synthesize apiKey;
@synthesize apiSecret;

+(id)sharedInstance
{
    static Lobbyist* instance = nil;
    if (!instance)
    {
        instance = [[[self class] singletonAlloc] init];
    }
    return instance;
}

+(id)singletonAlloc
{
    return [super alloc];
}

+(id)alloc
{
    NSLog(@"Lobbyist: use +sharedInstance instead of +alloc.");
    return nil;
}

+(id)new
{
    return [self alloc];
}

+(id)allocWithZone:(NSZone*)zone
{
    return [self alloc];
}

-(id)copyWithZone:(NSZone*)zone
{
    NSLog(@"Lobbyist: attempt to copy may be a bug.");
    return self;
}

-(id)mutableCopyWithZone:(NSZone*)zone
{
    return [self copyWithZone:zone];
}

@end