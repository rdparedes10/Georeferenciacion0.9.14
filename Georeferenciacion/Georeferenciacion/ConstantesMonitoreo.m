//
//  ConstantesMonitoreo.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 11/29/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "ConstantesMonitoreo.h"

@implementation ConstantesMonitoreo

//****URL Monitoreo
//NSString *const urlMonitoreo = @"http://ambienteprueba.000webhostapp.com";
//NSString *const urlMonitoreo = @"https://geolocalizacioncert.bancolombia.com:50019"; //Certificación
NSString *const urlMonitoreo = @"https://geolocalizacionprod.bancolombia.com:50019"; //Producción

//****URL Control Monitoreo
//NSString *const urlMonitoreoControl = @"http://104.131.1.186";
//NSString *const urlMonitoreoControl = @"https://geolocalizacioncert.bancolombia.com:50019"; //Certificación
NSString *const urlMonitoreoControl = @"https://geolocalizacionprod.bancolombia.com:50019"; //Producción

//****Path Monitoreo
//NSString *const path = @"/banco/ambienteBanco.php";
NSString *const path = @"/geolocalizacion/rest/add/postGeo";

//****Path Control Monitoreo
NSString *const pathMonitoreoControl = @"/geolocalizacion/rest/add/statusGeo";

//Warning Message
NSString *const message = @"Bancolombia APP utilizará su ubicación con el fin de mejorar el servicio. Usted puede cambiar los accesos en configuración del equipo.";

//Default Distance
float const distancia = 2000;//50000.0; //Distancia en Metros

//Default  TimeOut
int const timeOut = 15;


-(int)timeOut{
    
    return timeOut;
}

-(float)distancia{
    
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"distanceLocation"]>0.0) {
        return [[NSUserDefaults standardUserDefaults] floatForKey:@"distanceLocation"];
    }
    else {
        return distancia;
    }
}

-(NSString*)UrlPath{
    
    return [NSString stringWithFormat:@"%@%@",urlMonitoreo,path];
}

-(NSString*)getMessage{
    
    return message;
}

-(NSString*)UrlPathMonitoreoControl
{
    return [NSString stringWithFormat:@"%@%@",urlMonitoreoControl,pathMonitoreoControl];
}

@end
