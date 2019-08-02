//
//  smartWatchRepository.h
//  GeoreferenciacionSmartWatch
//
//  Created by Ricardo Grajales on 9/28/17.
//  Copyright © 2017 Ricardo Grajales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BCAFNetworking/AFNetworking.h>
#import "Constants.h"

@protocol smartWatchRepositoryDelegate;

@interface smartWatchRepository : NSObject
{
    id <smartWatchRepositoryDelegate> __unsafe_unretained smartWatchDelegate;
    Constants *constant;
}

@property (nonatomic, assign) id <smartWatchRepositoryDelegate> smartWatchDelegate;

-(void)getChannelDetails:(NSString*)typeID withLatitude:(float)latitude andLongitude:(float)longitude;
-(void)getChannelTypes;

@end

@protocol smartWatchRepositoryDelegate

-(void)getSmartWatchChannelTypes:(NSMutableArray *)channelTypesArray;
-(void)getSmartWatchChannelDetails:(NSMutableArray *)channelDetailsArray;

@end
