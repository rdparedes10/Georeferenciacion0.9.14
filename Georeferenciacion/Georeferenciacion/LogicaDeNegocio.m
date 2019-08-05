//
//  LogicaDeNegocio.m
//  SSL pinning iOS
//
//  Created by Samuel Romero on 8/09/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import "LogicaDeNegocio.h"

@implementation LogicaDeNegocio

int reintento = 0;

-(id)init {
    
    if (self = [super init])
    {
        _constantes = [[ConstantesMonitoreo alloc] init];
    }
    return self;
}

-(BOOL)compareDistacia:(CLLocation*)referencia nuevaUbicacion:(CLLocation*)ubicacion {
    
    CLLocationDistance meters = [referencia distanceFromLocation:ubicacion];
    
    if (meters > [_constantes distancia]) {
        
        NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"info"]];
        info[@"lat"] = [NSNumber numberWithFloat:ubicacion.coordinate.latitude];
        info[@"lng"] = [NSNumber numberWithFloat:ubicacion.coordinate.longitude];
        info[@"state"] = @NO;
        NSDictionary *Dic = info;
        [[NSUserDefaults standardUserDefaults] setObject:Dic forKey:@"info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return YES;
    }
    
    return NO;
}

-(BOOL)requestState {

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"info"][@"state"] boolValue]) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)compareTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    
    float timeToNotify=[[NSUserDefaults standardUserDefaults] floatForKey:@"timeLocation"];
    float lastTimeSent=[[NSUserDefaults standardUserDefaults] floatForKey:@"lastTimeSent"];
    float currentTime=[components hour];
    
    if (currentTime >= timeToNotify + lastTimeSent) {
        
        [[NSUserDefaults standardUserDefaults] setFloat:currentTime forKey:@"lastTimeSent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return YES;
    }
    
    return NO;
}

-(BOOL)requestResponseMSG:(NSString*)response{

    if ([@"001" isEqualToString:response] && reintento < 1) {
        
        reintento ++;
        
        return YES;
    }
    
    return NO;
}

@end
