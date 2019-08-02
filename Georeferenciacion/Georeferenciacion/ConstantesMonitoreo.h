//
//  ConstantesMonitoreo.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 11/29/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstantesMonitoreo : NSObject

@property (nonatomic,strong) NSString *const urlMonitoreo;
@property (nonatomic,strong) NSString *const path;
@property (nonatomic) float const distancia;
@property (nonatomic,strong) NSString *const message;

-(float)distancia;
-(NSString*)UrlPath;
-(NSString*)getMessage;
-(int)timeOut;
-(NSString*)UrlPathMonitoreoControl;

@end
