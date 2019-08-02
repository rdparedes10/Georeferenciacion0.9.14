//
//  Constants.h
//  GeoreferenciacionSmartWatch
//
//  Created by Ricardo Grajales on 9/28/17.
//  Copyright © 2017 Ricardo Grajales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

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

//Back-End Intergrupo
- (NSString *)urlAddPathService;
- (NSString *)urlAddPathChannels;
-(NSString *)urlAddPathMessage;

@end
