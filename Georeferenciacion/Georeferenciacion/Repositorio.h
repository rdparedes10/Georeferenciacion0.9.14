//
//  Repositorio.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 21/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BCAFNetworking/AFNetworking.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Constantes.h"

@protocol repositorioDelegate;

@interface Repositorio : NSObject <NSURLSessionTaskDelegate>
{
    id <repositorioDelegate> __unsafe_unretained delegate;
    Constantes *constante;
}

@property (nonatomic, assign) id <repositorioDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arraySedes;
@property (nonatomic, strong) NSMutableArray *arrayCanales;

-(void)filtrarCanales:(NSMutableDictionary*)parametros;

-(void)crearRuta:(float)latOrigen lngOrigen:(float)lngOrigen latDestino:(float)latDestino lngDestino:(float)lngDestino tipoDeRuta:(NSString*)tipo;

-(void)consultarCanales;

-(void)consultarMensajesParametrizables;

-(void)Reachability;

@end

@protocol repositorioDelegate

-(void)Reachability:(int)status;

@optional

-(void)sedes:(NSMutableArray *)sedes;
-(void)movimientoEnMapa:(NSMutableArray *)canalesEncontrados;
-(void)canales:(NSMutableArray *)canales;
-(void)parametrosYmensajes:(NSMutableDictionary *)parametrosYmensajes;
-(void)ruta:(GMSPath *)puntos tipo:(NSString*)tipo exepciones:(NSString*)exepcion;

@end
