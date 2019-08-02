//
//  Monitoreo.m
//  SSL pinning iOS
//
//  Created by Samuel Romero on 8/09/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import "Monitoreo.h"
#import "LogicaDeNegocio.h"

@implementation Monitoreo

-(id)initWithOtherId:(NSString*)otherId {
    
    if (self = [super init])
    {
        self.constantes = [[ConstantesMonitoreo alloc] init];
        
        self.Control=[[MonitoreoControl alloc] init];
        
        //Switch Georeferenciacion
        [self.Control MonitoreoControlWithURLString:[self.constantes UrlPathMonitoreoControl] WithTimeOut:[self.constantes timeOut] completionBlock:^(BOOL state, float Distance) {

            if (state) {
                
                self.repositorio = [[MonitoreoRepositorio alloc] init];
                self.repositorio.delegate = self;
                
                self.mensaje = [[Mensaje alloc] init];
                
                self.logica = [[LogicaDeNegocio alloc] init];
                
                self.firstOpen = NO;
                
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"info"]) {
                    
                    self.firstOpen = YES;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@{@"otherId":otherId,@"lat":[NSNumber numberWithFloat:0.0],@"lng":[NSNumber numberWithFloat:0.0],@"state":@YES,@"locationEnabled":@NO} forKey:@"info"];
                }
                
                self.locationManager = [[CLLocationManager alloc] init];
                
                // Set the delegate
                self.locationManager.delegate = self;
                
                // Request location authorization
                if (@available(iOS 8.0, *)) {
                    //[self.locationManager requestWhenInUseAuthorization];
                    [self.locationManager requestAlwaysAuthorization];
                }
            }
            
        }];
    }
    
    return self;
}

#pragma mark visit Location Monitoring

-(void)visitLocationUpdate {
    
    if (@available(iOS 8.0, *)) {
        [self.locationManager startMonitoringVisits];
    }
}

-(void)stopVisitLocationUpdate {

    if (@available(iOS 8.0, *)) {
        [self.locationManager stopMonitoringVisits];
    }
}

#pragma mark tracking Location Monitoring

-(void)trackingLocationUpdate {
    
    NSMutableDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
    
    self.referencia = [[CLLocation alloc] initWithLatitude:[info[@"lat"] floatValue] longitude:[info[@"lng"] floatValue]];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    // Enable automatic pausing
    //self.locationManager.pausesLocationUpdatesAutomatically = YES;
    
    // Specify the type of activity your app is currently performing
    self.locationManager.activityType = CLActivityTypeFitness;
    
    // Enable background location updates
    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        if (@available(iOS 9.0, *)) {
            [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        }
    }
    
    // Start location updates
    [self.locationManager startUpdatingLocation];
}

-(void)stopTrackingLocationUpdate {

    [self.locationManager stopUpdatingLocation];
}

#pragma mark significant Location Monitoring

-(void)significantLocationUpdate {
    
    [self.locationManager startMonitoringSignificantLocationChanges];
}

-(void)stopsignificantLocationUpdate {
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark listening Locations Updates

-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    LogicaDeNegocio *distacia = [[LogicaDeNegocio alloc] init];
    
    if ([distacia compareDistacia:self.referencia nuevaUbicacion:manager.location]) {

        self.referencia = [[CLLocation alloc] initWithLatitude:manager.location.coordinate.latitude longitude:manager.location.coordinate.longitude];
        
        NSMutableDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
        
        [_repositorio request:[_constantes UrlPath] dictionaryJSON:@{@"otherId":info[@"otherId"],@"latitud":[NSNumber numberWithFloat:manager.location.coordinate.latitude],@"longitud":[NSNumber numberWithFloat:manager.location.coordinate.longitude]} methodString:@"POST" timeOut:[_constantes timeOut]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    LogicaDeNegocio *distacia = [[LogicaDeNegocio alloc] init];

    if ([distacia compareDistacia:self.referencia nuevaUbicacion:manager.location]) {
        
        NSMutableDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
        
        self.referencia= [[CLLocation alloc] initWithLatitude:manager.location.coordinate.latitude longitude:manager.location.coordinate.longitude];
        
        [_repositorio request:[_constantes UrlPath] dictionaryJSON:@{@"otherId":info[@"otherId"],@"latitud":[NSNumber numberWithFloat:manager.location.coordinate.latitude],@"longitud":[NSNumber numberWithFloat:manager.location.coordinate.longitude]} methodString:@"POST" timeOut:[_constantes timeOut]];
    }
}

#pragma mark autorization Location

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"info"]];
    
    if (@available(iOS 8.0, *)) {
        
        switch (status) {
                
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"monitoreoMessage"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"monitoreoMessage"];
                    
                    [_mensaje showMessage:nil message:[self.constantes getMessage] cancelButton:@"Aceptar" actionButton:nil];
                }
                
                [self trackingLocationUpdate];
                //[self visitLocationUpdate];
                //[self significantLocationUpdate];
                
                info[@"locationEnabled"] = @YES;
                
                if (![self.logica requestState] && !self.firstOpen) {
                    
                    info[@"state"] = @NO;
                    
                    [_repositorio request:[_constantes UrlPath] dictionaryJSON:@{@"otherId":info[@"otherId"],@"latitud":info[@"lat"],@"longitud":info[@"lng"]} methodString:@"POST" timeOut:[_constantes timeOut]];
                }
            }
                break;
                
            default:{
                
                info[@"locationEnabled"] = @NO;
                
                if (!self.firstOpen && self.logica.compareTime) {
                    
                    info[@"lat"] = @0;
                    info[@"lng"] = @0;
                    info[@"state"] = @NO;
                    
                    [_repositorio request:[_constantes UrlPath] dictionaryJSON:@{@"otherId":info[@"otherId"],@"latitud":[NSNumber numberWithFloat:0],@"longitud":[NSNumber numberWithFloat:0]} methodString:@"POST" timeOut:[_constantes timeOut]];
                }
                
                self.firstOpen = NO;
            }
                break;
        }
        
        NSDictionary *Dic = info;
        [[NSUserDefaults standardUserDefaults] setObject:Dic forKey:@"info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark error Location
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"locationManager %@",error);
}

#pragma mark requestDelegate Response
-(void)requestResponse:(NSString*)response errorState:(BOOL)error{

    if (!error) {
        
        NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"info"]];
        info[@"state"] = @YES;
        NSDictionary *Dic = info;
        [[NSUserDefaults standardUserDefaults] setObject:Dic forKey:@"info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([self.logica requestResponseMSG:response]) {
            
            [_repositorio request:[_constantes UrlPath] dictionaryJSON:@{@"otherId":info[@"otherId"],@"latitud":[NSNumber numberWithFloat:0],@"longitud":[NSNumber numberWithFloat:0]} methodString:@"POST" timeOut:[_constantes timeOut]];
        }
    }
    else {
    
        NSMutableDictionary *info = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"info"]];
        info[@"state"] = @NO;
        NSDictionary *Dic = info;
        [[NSUserDefaults standardUserDefaults] setObject:Dic forKey:@"info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
