//
//  Lobbyist.h
//  Lobbyist
//
//  Created by David Lains on 9/26/13.
//  Copyright (c) 2013 Customer Lobby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lobbyist : NSObject

@property(nonatomic, retain) NSString* apiKey;
@property(nonatomic, retain) NSString* apiSecret;

+(id)sharedInstance;

@end
