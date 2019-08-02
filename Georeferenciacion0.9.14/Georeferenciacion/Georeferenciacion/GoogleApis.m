//
//  GoogleApis.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 23/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "GoogleApis.h"

@implementation GoogleApis

@synthesize delegate;

-(void)autoComplete:(NSString*)word{
    
}

-(void)getLatLngWithLocationId:(NSString*)placeId{

    GMSPlacesClient *client = [[GMSPlacesClient alloc] init];
    
    [client lookUpPlaceID:placeId callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            [delegate getLatLng:place.coordinate];
        } else {
            NSLog(@"No place details for %@", placeId);
        }
    }];
}

@end
