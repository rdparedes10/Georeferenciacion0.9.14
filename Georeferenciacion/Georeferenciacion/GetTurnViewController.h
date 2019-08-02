//
//  GetTurnViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 27/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modelo.h"
#import "BaseViewController.h"

@protocol getTurnDelegate;

@interface GetTurnViewController : BaseViewController <qflowRequestProtocolDelegate,UIAlertViewDelegate>{

    id<getTurnDelegate> __unsafe_unretained delegate;

}

@property (assign,nonatomic) id <getTurnDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *service;
@property (weak, nonatomic) IBOutlet UIImageView *iconService;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *minute;
@property (weak, nonatomic) IBOutlet UILabel *people;
@property (strong, nonatomic) NSMutableDictionary *model;
@property (strong, nonatomic) Modelo *modelo;
@property (strong, nonatomic) NSString *nameStr;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *tiempoTitulo;
@property (weak, nonatomic) IBOutlet UILabel *personasTitulo;
@property (weak, nonatomic) IBOutlet UIButton *solicitarTurno;

- (IBAction)close;

@end

@protocol getTurnDelegate

-(void)getTurn:(NSDictionary*)response;

@end
