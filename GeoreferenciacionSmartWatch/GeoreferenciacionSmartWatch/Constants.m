//
//  Constants.m
//  GeoreferenciacionSmartWatch
//
//  Created by Ricardo Grajales on 9/28/17.
//  Copyright © 2017 Ricardo Grajales. All rights reserved.
//

#import "Constants.h"

@implementation Constants

//@"http://bancolombia-georeferenciacion-ig-dllo-api.azurewebsites.net/api/"
//@"https://bancolombia-georeferenciacion-dllo-api.azurewebsites.net/api/"
//@"https://puntosdeatencioncert.bancolombia.com/GeorreferenciacionAPI/API/"

//NSString *const url = @"http://bancolombia-georeferenciacion-dllo-api.azurewebsites.net/api/"; //PRUEBAS IG
NSString *const url = @"https://puntosdeatencioncert.bancolombia.com/GeorreferenciacionAPI/API/"; //BANCO
//NSString *const url = @"https://puntosdeatencionprod.bancolombia.com/GeorreferenciacionAPI/API/"; //PRODUCCION

NSString *const pathService = @"Channels";
NSString *const pathChannels = @"ChannelTypes";
NSString *const pathMessages = @"Settings";
NSString *const pathValidateOfficce = @"Channels/CanEnqueueCase/%d/%@";
NSString *const googleKey = @"AIzaSyAClh9YC9PcCEBs7eUdg6OAraDsNB4_wNc";
NSString *const urlQflowUsers = @"https://serviciosdpcert.bancolombia.com:59039/UserAPI.aspx?";//PRUEBAS
//NSString *const urlQflowUsers = @"https://serviciosdpprod.bancolombia.com:59039/UserAPI.aspx?";//PRODUCCION
NSString *const urlQflowServices = @"https://serviciosdpcert.bancolombia.com:59041/QueueAPI.aspx?";//PRUEBAS
//NSString *const urlQflowServices = @"https://serviciosdpprod.bancolombia.com:59041/QueueAPI.aspx?";//PRODUCCION


-(NSString *)urlAddPathService {
    return [NSString stringWithFormat:@"%@%@",url,pathService];
}

-(NSString *)urlAddPathChannels {
    return [NSString stringWithFormat:@"%@%@",url,pathChannels];
}

-(NSString *)urlAddPathMessage {
    return [NSString stringWithFormat:@"%@%@",url,pathMessages];
}

-(NSString *)urlAddPathValidate {
    return [NSString stringWithFormat:@"%@%@",url,pathValidateOfficce];
}


@end
