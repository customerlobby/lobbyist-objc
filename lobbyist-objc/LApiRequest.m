//
//  LApiRequest.m
//  lobbyist-objc
//
//  Created by David Lains on 9/29/13.
//  Copyright (c) 2013 Customer Lobby. All rights reserved.
//

#import "LApiRequest.h"
#import <CommonCrypto/CommonHMAC.h>

@interface LApiRequest ()

-(NSString*)authorizationDataWithMethod:(NSString*)method params:(NSMutableDictionary*)params;
-(NSString*)generateSignatureWithMethod:(NSString*)method params:(NSMutableDictionary*)params;
-(NSString*)messageFromSortedParams:(NSMutableDictionary*)sortedParams;
-(NSString*)stringifyDictionary:(NSMutableDictionary*)dictionary;
-(NSMutableDictionary*)sortParams:(NSMutableDictionary*)params;
-(NSString*)hmacFromMessage:(NSString*)message;
-(NSString*)UTCDate;

@end

@implementation LApiRequest

+(id)requestWithURL:(NSURL*)url method:(NSString*)method formParameters:(NSMutableDictionary*)params
{
    return [[self alloc] initWithURL:url method:method formParameters:params];
}

-(id)initWithURL:(NSURL*)url method:(NSString*)method formParameters:(NSMutableDictionary*)params
{
    if ((self = [super initWithURL:url]))
    {
        [self setHTTPMethod:method];
        [self setValue:[self authorizationDataWithMethod:method params:params] forHTTPHeaderField:@"Authorization"];
        if ([method isEqualToString:@"put"] || [method isEqualToString:@"post"])
        {
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            NSString* body = [self stringifyDictionary:params];
            [self setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
            [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forKey:@"Content-Length"];
        }
        else if ([method isEqualToString:@"get"])
        {
            
        }
    }
    return self;
}

-(NSString*)authorizationDataWithMethod:(NSString*)method params:(NSMutableDictionary*)params
{
    NSString* result = [NSString stringWithFormat:@"Token token=\"%@\", signature=\"%@\"", [[Lobbyist sharedInstance] apiKey], [self generateSignatureWithMethod:method params:params]];
    return result;
}

-(NSString*)generateSignatureWithMethod:(NSString*)method params:(NSMutableDictionary*)params
{
    [params setValue:method forKey:@"method"];
    [params setValue:[self UTCDate] forKey:@"nonce"];
    
    NSMutableDictionary* sortedParams = [self sortParams:params];
    NSString* message = [self messageFromSortedParams:sortedParams];
    
    // Remove unneeded params.
    [params removeObjectForKey:@"method"];
    [params removeObjectForKey:@"id"];
    [params removeObjectForKey:@"activation_code"];
    [params removeObjectForKey:@"key"];
    
    return [self hmacFromMessage:message];
}

-(NSString*)messageFromSortedParams:(NSMutableDictionary*)sortedParams
{
    NSMutableString* message = [[NSMutableString alloc] init];
    
    [sortedParams enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL* stop) {
        if ([message length] == 0)
        {
            [message appendString:@"&"];
        }
        
        if ([object isKindOfClass:[NSMutableDictionary class]])
        {
            [message appendFormat:@"%@=%@", [key stringValue], [self stringifyDictionary:object]];
        }
        else
        {
            [message appendFormat:@"%@=%@", [key stringValue], [object stringValue]];
        }
    }];
    
    return result;
}

-(NSString*)stringifyDictionary:(NSMutableDictionary*)dictionary
{
    if ([[dictionary allKeys] count] == 0)
    {
         return @"{}";
    }

    NSMutableString* result = [[NSMutableString alloc] init];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL* stop) {
        if ([result length] == 0)
        {
            [result appendString:@"{"];
        }
        else
        {
            [result appendString:@","];
        }
    
        // TODO: Probably need to check for NULL object values, arrays, and replace \r\n with just \n, and replace embedded " with \".
        [result appendFormat:@"\"%@\"=>\"%@\"", [key stringValue], [object stringValue]];
    }];
    
    [result appendString:@"}"];
    
    return result;
}

-(NSMutableDictionary*)sortParams:(NSMutableDictionary*)params
{
    NSMutableDictionary* sorted = [[NSMutableDictionary alloc] init];
    
    NSArray* sortedKeys = [[params allKeys] sortedArrayUsingComparator:^(id object1, id object2) {
        return [[object1 stringValue] caseInsensitiveCompare:[object2 stringValue]];
    }];
    
    [sortedKeys enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL* stop) {
        [sorted setObject:[params valueForKey:[object stringValue]] forKey:[object stringValue]];
    }];
    
    return sorted;
}

-(NSString*)hmacFromMessage:(NSString*)message
{
    const char* cKey  = [[[Lobbyist sharedInstance] apiSecret] cStringUsingEncoding:NSASCIIStringEncoding];
    const char* cData = [message cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < sizeof(cHMAC); i++)
    {
        [result appendFormat:@"%02hhx", cHMAC[i]];
    }
    
    return result;
}

-(NSString*)UTCDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
