//
//  QflowRequest.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 31/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "QflowRequest.h"
#import "Constantes.h"

@implementation QflowRequest

@synthesize delegate;

-(id)init{
    
    if (self = [super init])
    {
        constante = [[Constantes alloc] init];
    }
    return self;
}

-(void)registerActivateLogin:(NSString*)uniqueId{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlQflowAddPathRegister],uniqueId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSLog(@"url %@",[NSString stringWithFormat:[constante urlQflowAddPathRegister],uniqueId]);
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            //[delegate qflowErrorRequest:error];
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            json = json[@"objReturnValue"];
            
            if (![json[@"ReturnCode"] boolValue])
                [self Activate:uniqueId];
            else if ([json[@"ReturnCode"] boolValue] && [json[@"ReturnMessage"] isEqualToString:@"El télefono ya existe"]){
                
                [self Activate:uniqueId];
            }
            else
                NSLog(@"Fallo el registro en Qflow");
                
        }
    }];
    [dataTask resume];
}

-(void)Activate:(NSString*)uniqueId{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlQflowAddPathActivate],uniqueId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            [delegate qflowErrorRequest:error];
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            json = json[@"objReturnValue"];
            
            [self login:uniqueId];
        }
    }];
    [dataTask resume];
}

-(void)login:(NSString*)uniqueId{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlQflowAddPathLogIn], uniqueId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [delegate qflowErrorRequest:error];
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            [delegate registerActivateLogin:(NSDictionary*)json];
            //[self qflowLogin];
        }
    }];
    [dataTask resume];
}

-(void)obtenerInformacionDeEspera:(NSString*)channelId serviceId:(int)serviceId{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlQflowAddPathTimeAndUsers],channelId,serviceId]];
    
    NSLog(@"%@",[NSString stringWithFormat:[constante urlQflowAddPathTimeAndUsers],channelId,serviceId]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [delegate qflowErrorRequest:error];
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Get Data %@",json);
            
            if ([json isKindOfClass:[NSArray class]]){
                if(((NSArray*)json).count>0)
                    [delegate tiemposDeEspera:(NSDictionary*)[json objectAtIndex:0]];
                else
                    [delegate qflowErrorRequest:error];
            }
            else
                [delegate qflowErrorRequest:error];
                
            
            //[delegate tiemposDeEspera:(NSDictionary*)json[0]];
            //[self qflowLogin];
        }
    }];
    [dataTask resume];
}

-(void)obtenerTurno:(int)serviceId customerId:(NSString*)customerId unitId:(int)unitId{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlQflowAddPathGetTurn],serviceId,customerId,unitId]];
    
    NSLog(@"%@",[NSString stringWithFormat:[constante urlQflowAddPathGetTurn],serviceId,customerId,unitId]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [delegate qflowErrorRequest:error];
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Get Turn %@",json);
            [delegate turno:(NSDictionary*)json];
        }
    }];
    [dataTask resume];
}

-(void)activarTurno:(int)unidId processId:(int)processId{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlQflowAddPathActivateTurn],unidId,processId]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [delegate qflowErrorRequest:error];
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Activate Turn %@",json);
            [delegate turnoActivado:(NSDictionary*)json];
        }
    }];
    [dataTask resume];
}

-(void)cancelarTurno:(int)processId{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlQflowAddPathCancelTurn],processId]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [delegate qflowErrorRequest:error];
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Cancel Turn %@",json);
            [delegate turnoCancelado:(NSDictionary*)json];
        }
    }];
    [dataTask resume];
}

-(void)validarSedeParaActivarTurno:(int)channelType processId:(NSString*)internalCode{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //NSLog(@"channel url: %@",[constante urlAddPathChannels]);
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:[constante urlAddPathValidate],channelType,internalCode]];
    
    NSLog(@"%@",URL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [delegate qflowErrorRequest:error];
        } else {
            
            [delegate validaciondeSede:[responseObject[@"status"] boolValue]];
        }
    }];
    [dataTask resume];
}

@end
