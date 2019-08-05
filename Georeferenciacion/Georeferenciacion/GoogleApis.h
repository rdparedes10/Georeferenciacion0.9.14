//
//  GoogleApis.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 23/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BCAFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Constantes.h"

@protocol googleApisRequest;

@interface GoogleApis : NSObject <NSURLSessionTaskDelegate>
{
    id <googleApisRequest> __unsafe_unretained delegate;
    Constantes *constante;
}

@property (nonatomic, assign) id <googleApisRequest> delegate;

-(void)autoComplete:(NSString*)word;
-(void)getLatLngWithLocationId:(NSString*)placeId;

@end

@protocol googleApisRequest

@optional

-(void)autoCompleteWord:(NSString *)words;
-(void)getLatLng:(CLLocationCoordinate2D)coordinate;

@end
