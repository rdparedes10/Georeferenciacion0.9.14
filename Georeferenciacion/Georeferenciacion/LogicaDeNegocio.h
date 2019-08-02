//
//  LogicaDeNegocio.h
//  SSL pinning iOS
//
//  Created by Samuel Romero on 8/09/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ConstantesMonitoreo.h"
@interface LogicaDeNegocio : NSObject

@property (strong, nonatomic) ConstantesMonitoreo *constantes;

-(BOOL)compareDistacia:(CLLocation*)referencia nuevaUbicacion:(CLLocation*)referencia;

-(BOOL)compareTime;

-(BOOL)requestState;

-(BOOL)requestResponseMSG:(NSString*)response;

@end
