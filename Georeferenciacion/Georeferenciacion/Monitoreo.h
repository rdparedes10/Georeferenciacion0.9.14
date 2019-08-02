//
//  Monitoreo.h
//  SSL pinning iOS
//
//  Created by Samuel Romero on 8/09/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LogicaDeNegocio.h"
#import "MonitoreoRepositorio.h"
#import "ConstantesMonitoreo.h"
#import "Mensaje.h"
#import "MonitoreoControl.h"

@interface Monitoreo : NSObject<CLLocationManagerDelegate, monitoreoRepositorioDelegate, messageDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *referencia;
@property (strong, nonatomic) MonitoreoRepositorio *repositorio;
@property (strong, nonatomic) LogicaDeNegocio *logica;
@property (strong, nonatomic) ConstantesMonitoreo *constantes;
@property (strong, nonatomic) Mensaje *mensaje;
@property (nonatomic) BOOL firstOpen;
@property (strong, nonatomic) MonitoreoControl *Control;

-(id)initWithOtherId:(NSString*)otherId;//Constructor 
-(void)visitLocationUpdate;
-(void)stopVisitLocationUpdate;
-(void)trackingLocationUpdate;
-(void)stopTrackingLocationUpdate;
-(void)significantLocationUpdate;
-(void)stopsignificantLocationUpdate;

@end
