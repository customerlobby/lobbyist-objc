//
//  LConnection.h
//  lobbyist-objc
//
//  Created by David Lains on 9/29/13.
//  Copyright (c) 2013 Customer Lobby. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LConnection;

typedef void (^LConnectionProgressBlock)(LConnection* connection);
typedef void (^LConnectionCompletionBlock)(LConnection* connection, NSError* error);

@interface LConnection : NSObject

@property(nonatomic, strong) NSMutableData* downloadData;
@property(nonatomic, assign) float percentComplete;
@property(nonatomic, assign) NSUInteger progressThreshold;

+(id) connectionWithURL:(NSURL*)url progressBlock:(LConnectionProgressBlock)progress completionBlock:(LConnectionCompletionBlock)completion;
+(id) connectionWithRequest:(NSURLRequest*)request progressBlock:(LConnectionProgressBlock)progress completionBlock:(LConnectionCompletionBlock)completion;

-(id) initWithURL:(NSURL*)url progressBlock:(LConnectionProgressBlock)progress completionBlock:(LConnectionCompletionBlock)completion;
-(id) initWithRequest:(NSURLRequest*)request progressBlock:(LConnectionProgressBlock)progress completionBlock:(LConnectionCompletionBlock)completion;

-(void) start;
-(void) stop;

@end
