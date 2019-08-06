//
//  messagesAndParameters.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 22/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "messagesAndParameters.h"

@implementation messagesAndParameters

-(NSDictionary*)mensaje:(NSString*)idMessage{

    NSArray *ar = (NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"mensajes"][@"messages"];
    
    for (int i = 0; i<ar.count; i++) {
        
        if ([ar[i][@"idMessage"] isEqualToString:idMessage]) {
            
            return ar[i];
        }
    }
    
    return nil;
}

-(NSString*)parametro:(int)idMParameter{

    NSArray *ar = (NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"mensajes"][@"parameters"];
    
    for (int i = 0; i<ar.count; i++) {
        
        if (ar[i][@"idParameter"] && [ar[i][@"idParameter"] intValue]==idMParameter) {
            
            return ar[i][@"parameterValue"];
        }
    }
    
    return nil;
}

@end
