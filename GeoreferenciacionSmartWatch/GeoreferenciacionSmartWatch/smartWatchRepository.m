//
//  smartWatchRepository.m
//  GeoreferenciacionSmartWatch
//
//  Created by Ricardo Grajales on 9/28/17.
//  Copyright © 2017 Ricardo Grajales. All rights reserved.
//

#import "smartWatchRepository.h"

@implementation smartWatchRepository

@synthesize smartWatchDelegate;

NSMutableDictionary *queryChannelDetailsParameters;

-(id)init
{
    if (self = [super init])
    {
        constant=[[Constants alloc] init];
    }
    return self;
}

-(void)getChannelDetails:(NSString*)typeID withLatitude:(float)latitude andLongitude:(float)longitude
{
    queryChannelDetailsParameters = [[NSMutableDictionary alloc] initWithDictionary:
                                     @{@"latitude":[NSNumber numberWithFloat:latitude],
                                       @"longitude":[NSNumber numberWithFloat:longitude],
                                       @"idType":typeID,
                                       @"radioInKms":@"",
                                       @"filterProperties":[[NSMutableArray alloc] init],
                                       @"userLatitude":[NSNumber numberWithFloat: latitude],
                                       @"userLongitude":[NSNumber numberWithFloat: longitude]}];
    
    [self getChannelDetailsWithParameters:queryChannelDetailsParameters];
}

-(void)getChannelDetailsWithParameters:(NSMutableDictionary*)parameters
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[constant urlAddPathService] parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (!error) {
            [smartWatchDelegate getSmartWatchChannelDetails:[self arraySmartWatchChannelDetails:responseObject[@"channels"]]];
        }
        
    }];
    [dataTask resume];
}

-(void)getChannelTypes
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[constant urlAddPathChannels]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            [smartWatchDelegate getSmartWatchChannelTypes:nil];
            
        }
        else {
            
            [smartWatchDelegate getSmartWatchChannelTypes:[self arraySmartWatchChannelTypes:responseObject[@"channelTypes"]]];
        }
    }];
    [dataTask resume];
}

-(NSMutableArray*)arraySmartWatchChannelTypes:(NSArray*)responseArray
{
    NSMutableArray *channelsArray=[[NSMutableArray alloc] init];
    
    for (int index=0; index<responseArray.count; index++) {
        NSMutableDictionary *channelDictionary=[[NSMutableDictionary alloc] init];
        [channelDictionary setObject:responseArray[index][@"channelTypeName"] forKey:@"channelTypeName"];
        [channelDictionary setObject:responseArray[index][@"idChannelType"] forKey:@"idChannelType"];
        
        [channelsArray addObject:channelDictionary];
        
    }
    return channelsArray;
}

-(NSMutableArray *)arraySmartWatchChannelDetails:(NSArray *)array
{
    NSMutableArray *channelsDetailArray=[[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        
        NSMutableDictionary *channelDictionary=[[NSMutableDictionary alloc] init];
        
        [channelDictionary setObject:[array objectAtIndex:i][@"channelName"] forKey:@"currentName"];
        [channelDictionary setObject:[array objectAtIndex:i][@"idChannelType"] forKey:@"channelId"];
        [channelDictionary setObject:[array objectAtIndex:i][@"distance"] forKey:@"distance"];
        [channelDictionary setObject:[array objectAtIndex:i][@"phoneNumber"] forKey:@"phoneNumber"];
        [channelDictionary setObject:[array objectAtIndex:i][@"address"] forKey:@"address"];
        [channelDictionary setObject:[array objectAtIndex:i][@"closeIn"] forKey:@"closeIn"];
        [channelDictionary setObject:[NSNumber numberWithFloat:[[array objectAtIndex:i][@"latitude"] floatValue]] forKey:@"latitude"];
        [channelDictionary setObject:[NSNumber numberWithFloat:[[array objectAtIndex:i][@"longitude"] floatValue]] forKey:@"longitude"];
        [channelDictionary setObject:[NSNumber numberWithBool:[[array objectAtIndex:i][@"isOpen"] boolValue]] forKey:@"isOpen"];
        [channelDictionary setObject:[NSNumber numberWithBool:[[array objectAtIndex:i][@"active"] boolValue]] forKey:@"active"];
        [channelDictionary setObject:[NSNumber numberWithBool:[[array objectAtIndex:i][@"hasQflow"] boolValue]] forKey:@"hasQflow"];
        [channelDictionary setObject:[array objectAtIndex:i][@"schedules"] forKey:@"schedules"];
        [channelDictionary setObject:[array objectAtIndex:i][@"services"] forKey:@"services"];
        [channelDictionary setObject:[array objectAtIndex:i][@"servicesQflow"] forKey:@"servicesQflow"];
        [channelDictionary setObject:[NSNumber numberWithInt:i] forKey:@"internId"];
        [channelDictionary setObject:[NSNumber numberWithInt:[[array objectAtIndex:i][@"secondsToClose"] intValue]] forKey:@"secondsToClose"];
        [channelDictionary setObject:[array objectAtIndex:i][@"internalCode"] forKey:@"internalCode"];
        
        [channelsDetailArray addObject:channelDictionary];
    }
    
    return channelsDetailArray;
}

@end
