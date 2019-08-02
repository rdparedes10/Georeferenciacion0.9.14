//
//  Constantes.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 4/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Constantes : NSObject

@property (nonatomic,strong) NSString *const url;
@property (nonatomic,strong) NSString *const urlQflowUsers;
@property (nonatomic,strong) NSString *const urlQflowServices;
@property (nonatomic,strong) NSString *const pathRegisterQflow;
@property (nonatomic,strong) NSString *const pathActivateQflow;
@property (nonatomic,strong) NSString *const pathLogInQflow;
@property (nonatomic,strong) NSString *const pathTimeAndUsersQflow;
@property (nonatomic,strong) NSString *const pathGetTurn;
@property (nonatomic,strong) NSString *const pathService;
@property (nonatomic,strong) NSString *const pathChannels;
@property (nonatomic,strong) NSString *const googleKey;
@property (nonatomic,strong) NSString *const pathMessages;
@property (nonatomic,strong) NSString *const pathValidateOfficce;
@property (nonatomic, strong) UIColor *colorPrecessBlack;
@property (nonatomic,strong) UIColor *colorBlue;
@property (nonatomic,strong) UIColor *colorRed;
@property (nonatomic,strong) UIColor *colorYellow;
@property (nonatomic,strong) UIColor *colorGold;
@property (nonatomic,strong) UIColor *colorGray;
@property (nonatomic,assign) float iPhoneXSafeHeight;
@property (nonatomic,assign) float iPhoneXTopInset;
@property (nonatomic,assign) float iPhoneXBottomInset;

//Back-End Intergrupo
- (NSString *)uuid;
- (NSString *)urlAddPathService;
- (NSString *)urlAddPathChannels;
-(NSString *)urlAddPathMessage;
- (UIImage*)iconodeCanal:(int)idType;
- (UIImage *)iconodeCanalConEfecto:(int)idType;
- (UIImage *)iconosdeServiciosQflow:(int)idType;
- (NSString *)nombredeCanal:(int)idType;
- (UIImage *)pindeCanal:(int)idType;

//Qflow
- (NSString *)urlQflowAddPathRegister;
- (NSString *)urlQflowAddPathActivate;
- (NSString *)urlQflowAddPathLogIn;
- (NSString *)urlQflowAddPathTimeAndUsers;
- (NSString *)urlQflowAddPathGetTurn;
- (NSString *)urlQflowAddPathActivateTurn;
- (NSString *)urlQflowAddPathCancelTurn;
- (NSString *)urlAddPathValidate;

@end
