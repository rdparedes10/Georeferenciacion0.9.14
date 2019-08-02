//
//  BaseViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 9/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Google/Analytics.h>
#import "messagesAndParameters.h"
#import "AyudasViewController.h"
#import "QflowRequest.h"
#import "Repositorio.h"
#import "Constantes.h"

@interface BaseViewController : UIViewController

@property(strong, nonatomic) UIAlertView *message;
@property(strong, nonatomic) id<GAITracker> tracker;
@property(strong, nonatomic) messagesAndParameters *messageParameters;
@property(strong, nonatomic) Constantes * constant;
@property(strong, nonatomic) Repositorio *request;
@property(strong, nonatomic) QflowRequest *qflowRequest;
@property(weak, nonatomic) MBProgressHUD *hud;
@property(strong, nonatomic) AyudasViewController *vc;
@property(nonatomic) float with;

-(void)message:(NSString*)messageTitle messageDescription:(NSString*)messageDescription cancelBtn:(NSString*)cancel otherBtn:(NSString*)other;
@end
