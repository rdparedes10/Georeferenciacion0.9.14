//
//  Modelo.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 21/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Modelo : NSObject
@property (nonatomic,strong) NSString *nombreactual;
@property (nonatomic,strong) NSString *canalId;
@property (nonatomic,strong) NSString *cierraEn;
@property (nonatomic,strong) NSString *nomenclatura;
@property (nonatomic,strong) NSString *distancia;
@property (nonatomic,strong) NSString *telefono;
@property (nonatomic,strong) NSArray *horarios;
@property (nonatomic,strong) NSArray *servicios;
@property (nonatomic,strong) NSArray *serviciosQflow;
@property (nonatomic) int idInterno;
@property (nonatomic) NSString* internalCode;
@property (nonatomic) int secondsToClose;
@property (nonatomic) float latitud;
@property (nonatomic) float longitud;
@property (nonatomic) BOOL oficinaAbierta;
@property (nonatomic) BOOL oficinaActiva;
@property (nonatomic) BOOL qflow;

@end
