//
//  Repositorio.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 21/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "Repositorio.h"
#import "Modelo.h"

@implementation Repositorio
@synthesize delegate,arraySedes,arrayCanales;

-(id)init{
    
    if (self = [super init])
    {
        constante = [[Constantes alloc] init];
    }
    return self;
}

-(void)Reachability{

    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"* %d Reachability: %@", (int)status, AFStringFromNetworkReachabilityStatus(status));
        [delegate Reachability:(int)status];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

-(void)filtrarCanales:(NSMutableDictionary*)parametros{
    
    //NSLog(@"parametros %@",parametros);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //NSLog(@"channels url: %@",[constante urlAddPathService]);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[constante urlAddPathService] parameters:parametros error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSLog(@"%@",(NSArray*)responseObject);
            [delegate sedes:[self arrayModelosDeCanal:responseObject[@"channels"]]];
        }
    }];
    [dataTask resume];

}

-(void)consultarCanales{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //NSLog(@"channel url: %@",[constante urlAddPathChannels]);
    
    NSURL *URL = [NSURL URLWithString:[constante urlAddPathChannels]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"channelTypes"] forKey:@"canales"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [delegate canales:(NSMutableArray *)responseObject[@"channelTypes"]];
        }
    }];
    [dataTask resume];
}

-(void)consultarMensajesParametrizables{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //NSLog(@"channel url: %@",[constante urlAddPathChannels]);
    
    NSURL *URL = [NSURL URLWithString:[constante urlAddPathMessage]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"mensajes"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [delegate parametrosYmensajes:(NSMutableDictionary *)responseObject];
        }
    }];
    [dataTask resume];
}

-(void)crearRuta:(float)latOrigen lngOrigen:(float)lngOrigen latDestino:(float)latDestino lngDestino:(float)lngDestino tipoDeRuta:(NSString*)tipo{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%.6f,%.6f&destination=%.6f,%.6f&mode=%@&key=AIzaSyAClh9YC9PcCEBs7eUdg6OAraDsNB4_wNc",latOrigen,lngOrigen,latDestino,lngDestino,tipo]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSLog(@"%@",responseObject);
            
            if ([[(NSDictionary *)responseObject objectForKey:@"routes"] count] > 0) {
                [delegate ruta:[GMSPath pathFromEncodedPath:responseObject[@"routes"][0][@"overview_polyline"][@"points"]] tipo:tipo exepciones:@"success"];
            }else{
            
                [delegate ruta:nil tipo:tipo exepciones:@"No se encontraron rutas"];
            }
            
        }
    }];
    [dataTask resume];
}

-(NSMutableArray *)arrayModelosDeCanal:(NSArray *)array{
    
    arraySedes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; i++) {
        
        Modelo *modelo = [[Modelo alloc] init];
        modelo.nombreactual = [array objectAtIndex:i][@"channelName"];
        modelo.canalId = [array objectAtIndex:i][@"idChannelType"];
        modelo.distancia = [array objectAtIndex:i][@"distance"];
        modelo.telefono = [array objectAtIndex:i][@"phoneNumber"];
        modelo.nomenclatura = [array objectAtIndex:i][@"address"];
        modelo.cierraEn = [array objectAtIndex:i][@"closeIn"];
        modelo.latitud = [[array objectAtIndex:i][@"latitude"] floatValue];
        modelo.longitud = [[array objectAtIndex:i][@"longitude"] floatValue];
        modelo.oficinaAbierta = [[array objectAtIndex:i][@"isOpen"] boolValue];
        modelo.oficinaActiva = [[array objectAtIndex:i][@"active"] boolValue];
        modelo.qflow = [[array objectAtIndex:i][@"hasQflow"] boolValue];
        modelo.horarios = [array objectAtIndex:i][@"schedules"];
        modelo.servicios = [array objectAtIndex:i][@"services"];
        modelo.serviciosQflow = [array objectAtIndex:i][@"servicesQflow"];
        modelo.idInterno = i;
        modelo.secondsToClose = [[array objectAtIndex:i][@"secondsToClose"] intValue];
        modelo.internalCode = [array objectAtIndex:i][@"internalCode"];
        [arraySedes addObject:modelo];
    }
    
    return arraySedes;
    
}

@end
