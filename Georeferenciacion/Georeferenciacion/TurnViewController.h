//
//  TurnViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 17/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TurnViewController : BaseViewController <qflowRequestProtocolDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *turn;
@property (weak, nonatomic) IBOutlet UILabel *tituloPrincipal;
@property (weak, nonatomic) IBOutlet UILabel *subTitulo;
@property (weak, nonatomic) IBOutlet UILabel *tituloCancelar;
@property (weak, nonatomic) IBOutlet UILabel *tituloEliminar;
- (IBAction)cancelar;
- (IBAction)eliminar;

@end
