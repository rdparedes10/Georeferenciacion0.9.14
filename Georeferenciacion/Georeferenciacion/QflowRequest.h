//
//  QflowRequest.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 31/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BCAFNetworking/AFNetworking.h>
#import "Constantes.h"

@protocol qflowRequestProtocolDelegate;

@interface QflowRequest : NSObject{

    id <qflowRequestProtocolDelegate> __unsafe_unretained delegate;
    Constantes *constante;

}

@property (assign,nonatomic) id <qflowRequestProtocolDelegate> delegate;

-(void)registerActivateLogin:(NSString *)uniqueId;

-(void)obtenerInformacionDeEspera:(NSString*)channelId serviceId:(int)serviceId;

-(void)obtenerTurno:(int)serviceId customerId:(NSString*)customerId unitId:(int)unitId;

-(void)validarSedeParaActivarTurno:(int)channelType processId:(NSString*)internalCode;

-(void)activarTurno:(int)unidId processId:(int)processId;

-(void)cancelarTurno:(int)processId;

@end

@protocol qflowRequestProtocolDelegate

-(void)qflowErrorRequest:(NSError*)error;

@optional

-(void)registerActivateLogin:(NSDictionary*)response;
-(void)tiemposDeEspera:(NSDictionary*)response;
-(void)turno:(NSDictionary*)response;
-(void)turnoCancelado:(NSDictionary*)response;
-(void)turnoActivado:(NSDictionary*)response;
-(void)validaciondeSede:(BOOL)response;
@end
