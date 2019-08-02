//
//  Constantes.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 4/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "Constantes.h"

@implementation Constantes
//@"http://bancolombia-georeferenciacion-ig-dllo-api.azurewebsites.net/api/"
//@"https://bancolombia-georeferenciacion-dllo-api.azurewebsites.net/api/"
//@"https://puntosdeatencioncert.bancolombia.com/GeorreferenciacionAPI/API/"

//NSString *const url = @"http://bancolombia-georeferenciacion-dllo-api.azurewebsites.net/api/"; //PRUEBAS IG
//NSString *const url = @"https://puntosdeatencioncert.bancolombia.com/GeorreferenciacionAPI/API/"; //BANCO
NSString *const url = @"https://puntosdeatencionprod.bancolombia.com/GeorreferenciacionAPI/API/"; //PRODUCCION
    
NSString *const pathService = @"Channels";
NSString *const pathChannels = @"ChannelTypes";
NSString *const pathMessages = @"Settings";
NSString *const pathValidateOfficce = @"Channels/CanEnqueueCase/%d/%@";
NSString *const googleKey = @"AIzaSyAMpN0MujDvbzsrupe4-A8wj1EiD_On6nE";

//NSString *const urlQflowUsers = @"https://serviciosdpcert.bancolombia.com:59039/UserAPI.aspx?";//PRUEBAS
NSString *const urlQflowUsers = @"https://serviciosdpprod.bancolombia.com:59039/UserAPI.aspx?";//PRODUCCION
//NSString *const urlQflowServices = @"https://serviciosdpcert.bancolombia.com:59041/QueueAPI.aspx?";//PRUEBAS
NSString *const urlQflowServices = @"https://serviciosdpprod.bancolombia.com:59041/QueueAPI.aspx?";//PRODUCCION
    
NSString *const pathRegisterQflow = @"Method=Register&FirstName=AppMovil&LastName=Bancolombia&Email=BancolombiaMovil@email.com&Password=iOS&Phone=%@&Language=es";
NSString *const pathActivateQflow = @"Method=ActivateCustomer&Phone=%@";
NSString *const pathLogInQflow = @"Method=Login&Phone=%@&Password=iOS&RegistrationId=122221&DeviceOS=iOS&Language=es";
NSString *const pathTimeAndUsersQflow = @"Method=GetUnitList&Name=&ZipCode=%@&Address=&City=&State=&ServiceProfileId=%d&Language=es";
NSString *const pathGetTurn = @"Method=EnqueueCase&ServiceProfileId=%d&CustomerId=%@&UnitId=%d&DeviceId=ABC123DEF&freeze=true";
NSString *const pathActivateTurn = @"Method=UnfreezeCase&UnitId=%d&ProcessId=%d";
NSString *const pathCancelTurn = @"Method=CancelCase&ProcessId=%d";

-(id)init {

    if (self = [super init])
    {
        _colorPrecessBlack = [UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:1.0];
        _colorBlue = [UIColor colorWithRed:0.0/255.0 green:68.0/255.0 blue:141.0/255.0 alpha:1.0];
        _colorRed = [UIColor colorWithRed:237.0/255.0 green:27.0/255.0 blue:45.0/255.0 alpha:1.0];
        _colorYellow = [UIColor colorWithRed:255.0/255.0 green:210.0/255.0 blue:0.0/255.0 alpha:1.0];
        _colorGold = [UIColor colorWithRed:180.0/255.0 green:142.0/255.0 blue:46.0/255.0 alpha:1.0];
        _colorGray = [UIColor colorWithRed:155.0/255.0 green:161.0/255.0 blue:164.0/255.0 alpha:1.0];
        _iPhoneXSafeHeight = 724.0;
        _iPhoneXTopInset = 44.0;
        _iPhoneXBottomInset = 34.0;
    }
    return self;
}

- (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

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

#pragma mark Qflow URL+Path

-(NSString *)urlQflowAddPathRegister {

    return [NSString stringWithFormat:@"%@%@",urlQflowUsers,pathRegisterQflow];
}

-(NSString *)urlQflowAddPathActivate {
    
    return [NSString stringWithFormat:@"%@%@",urlQflowUsers,pathActivateQflow];
}

-(NSString *)urlQflowAddPathLogIn {
    
    return [NSString stringWithFormat:@"%@%@",urlQflowUsers,pathLogInQflow];
}

-(NSString *)urlQflowAddPathTimeAndUsers {
    
    return [NSString stringWithFormat:@"%@%@",urlQflowServices,pathTimeAndUsersQflow];
}

-(NSString *)urlQflowAddPathGetTurn {
    
    return [NSString stringWithFormat:@"%@%@",urlQflowServices,pathGetTurn];
}

-(NSString *)urlQflowAddPathActivateTurn {
    
    return [NSString stringWithFormat:@"%@%@",urlQflowServices,pathActivateTurn];
}

-(NSString *)urlQflowAddPathCancelTurn {
    
    return [NSString stringWithFormat:@"%@%@",urlQflowServices,pathCancelTurn];
}

#pragma mark nombres y iconos

-(UIImage*)iconodeCanalConEfecto:(int)idType {
    
    switch (idType) {
        case 1:
            return [UIImage imageNamed:@"iconOffice"];
            break;
        case 2:
            return [UIImage imageNamed:@"iconCajero"];
            break;
        case 3:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        default:
            return [UIImage imageNamed:@"iconOffice"];
            break;
    }
}

-(UIImage*)iconodeCanal:(int)idType {
    
    switch (idType) {
            
        case 1:
            return [UIImage imageNamed:@"office"];
            break;
        case 2:
            return [UIImage imageNamed:@"cajero"];
            break;
        case 3:
            return [UIImage imageNamed:@"corresponsal"];
            break;
        default:
            return [UIImage imageNamed:@"office"];
            break;
    }
}

-(UIImage*)iconosdeServiciosQflow:(int)idType {
    
    switch (idType) {
        case 1:
            return [UIImage imageNamed:@"iconOffice"];
            break;
        case 2:
            return [UIImage imageNamed:@"iconCajero"];
            break;
        case 3:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        case 4:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        case 5:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        case 6:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        case 7:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        case 8:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        case 9:
            return [UIImage imageNamed:@"iconCorresponsal"];
            break;
        default:
            return [UIImage imageNamed:@"iconOffice"];
            break;
    }
}

-(UIImage*)pindeCanal:(int)idType {
    
    switch (idType) {
        case 1:
            return [UIImage imageNamed:@"pinOffice"];
            break;
        case 2:
            return [UIImage imageNamed:@"pinCajero"];
            break;
        case 3:
            return [UIImage imageNamed:@"pinCorresponsal"];
            break;
        default:
            return [UIImage imageNamed:@"pinOffice"];
            break;
    }
}

-(NSString*)nombredeCanal:(int)idType {
    
    switch (idType) {
        case 1:
            return @"Sucursales";
            break;
        case 2:
            return @"Cajeros";
            break;
        case 3:
            return @"Corresponsales";
            break;
        default:
            return @"Sucursales";
            break;
    }
}

@end
