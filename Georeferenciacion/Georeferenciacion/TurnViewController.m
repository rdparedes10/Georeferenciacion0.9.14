//
//  TurnViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 17/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "TurnViewController.h"

@interface TurnViewController ()

@end

@implementation TurnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _turn.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"TicketNumber"];
    
    self.qflowRequest.delegate = self;
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = flipButton;
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS25"];
    if (mensajeYParametros)
        _tituloPrincipal.text = mensajeYParametros[@"messageContent"];
    else
        _tituloPrincipal.text = @"Detalle del turno.";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS24"];
    if (mensajeYParametros)
        _subTitulo.text = mensajeYParametros[@"messageContent"];
    else
        _subTitulo.text = @"Tu número de turno es.";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS27"];
    if (mensajeYParametros)
        _tituloCancelar.text = mensajeYParametros[@"messageContent"];
    else
        _tituloCancelar.text = @"No podré esperar";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS28"];
    if (mensajeYParametros)
        _tituloEliminar.text = mensajeYParametros[@"messageContent"];
    else
        _tituloEliminar.text = @"Ya fui atendido";
}

-(void)back{

    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers>3) {
        
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 4];
        [self.navigationController popToViewController:vc animated:YES];
        
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)turnoCancelado:(NSDictionary*)response{
    
    [self.hud hide:YES];
    
        if ([response[@"ReturnCode"] integerValue] == 0) {
            
            
            [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Turno"
                                                                       action:@"Generado"
                                                                        label:@"Cancelado"
                                                                        value:@1] build]];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"turn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self back];
        }else{
            NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
            if (mensajeYParametros)
                [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
            else
                [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
    }
}

-(void)qflowErrorRequest:(NSError*)error{
    
    [self.hud hide:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelar {
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS19"];
    if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Cerrar" otherBtn:@"Cancelar turno"];
    else
        [self message:@"Información" messageDescription:@"¿Estás seguro que deseas cancelar este turno?" cancelBtn:@"Cerrar" otherBtn:@"Cancelar turno"];
}

- (IBAction)eliminar {
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS26"];
    if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Cerrar" otherBtn:@"Eliminar turno"];
    else
        [self message:@"Información" messageDescription:@"¿Estás seguro que deseas eliminar este turno?" cancelBtn:@"Cerrar" otherBtn:@"Eliminar turno"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1 && [[alertView buttonTitleAtIndex:buttonIndex]isEqual:@"Cancelar turno"]) {
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.qflowRequest cancelarTurno:[[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"ProcessId"] intValue]];
    }
    else if (buttonIndex == 1 && [[alertView buttonTitleAtIndex:buttonIndex]isEqual:@"Eliminar turno"]) {
        
        [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Turno"
                                                                   action:@"Generado"
                                                                    label:@"Eliminado"
                                                                    value:nil] build]];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"turn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self back];
    }
}

@end
