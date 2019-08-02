//
//  GetTurnViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 27/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "GetTurnViewController.h"
#import "QflowTurnViewController.h"
#import "Constantes.h"

@interface GetTurnViewController ()

@end

@implementation GetTurnViewController

@synthesize name,service,iconService,hour,minute,people,delegate,titulo,tiempoTitulo,personasTitulo,solicitarTurno;

int unitID=-1;
int tiempo=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    tapGesture.numberOfTapsRequired=1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGesture];
    
    name.text = _nameStr;
    
    if ([_model[@"serviceName"] isEqual: @"Caja."]) {
        service.text = @"El monto máximo por turno es de $10'.000.000";
    } else {
        service.text = _model[@"serviceName"];
    }
    
    iconService.image = [UIImage imageNamed:[(NSString*)_model[@"image"] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
    iconService.image = [iconService.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [iconService setTintColor:self.constant.colorPrecessBlack];
    
    self.qflowRequest.delegate = self;
    [self.qflowRequest obtenerInformacionDeEspera:_modelo.internalCode serviceId:[_model[@"idQflowService"]intValue]];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    
    [self setParameters];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    self.qflowRequest.delegate = nil;
}

-(void)setParameters{

    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS08"];
    if (mensajeYParametros)
        titulo.text = mensajeYParametros[@"messageContent"];
    else
        titulo.text = @"Servicio Solicitado";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS09"];
    if (mensajeYParametros)
        tiempoTitulo.text = mensajeYParametros[@"messageContent"];
    else
        tiempoTitulo.text = @"Tiempo estimado de espera";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS10"];
    if (mensajeYParametros)
        personasTitulo.text = mensajeYParametros[@"messageContent"];
    else
        personasTitulo.text = @"Personas en espera en fila";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS11"];
    if (mensajeYParametros)
        [self.solicitarTurno setTitle:[NSString stringWithFormat:@"  %@  ",mensajeYParametros[@"messageContent"]] forState:UIControlStateNormal];
    else
        [self.solicitarTurno setTitle:@"  Solicitar Turno  " forState:UIControlStateNormal];
}

-(void)tiemposDeEspera:(NSDictionary*)response{
    
    [self.hud hide:YES];
    
    if (response) {
     
        tiempo = [response[@"EstimatedWaitingTime"] intValue];
        CGFloat horas = tiempo/3600;
        CGFloat minutos = (tiempo-(horas*3600))/60;
        
        if (horas>=2 || horas < 1)
            hour.text = [NSString stringWithFormat:@"%.0f horas",horas];
        else
            hour.text = [NSString stringWithFormat:@"%.0f Hora",horas];
        
        if (minutos>=2 || minutos < 1)
            minute.text = [NSString stringWithFormat:@"%.0f minutos",minutos];
        else
            minute.text = [NSString stringWithFormat:@"%.0f minuto",minutos];
        
        people.text = [NSString stringWithFormat:@"%d",[response[@"WaitingCount"] intValue]];
        unitID = [response[@"UnitId"] intValue];
    }
}

- (IBAction)getTurn{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]) {
        
        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"dateXpiration"];
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
        
        NSString *parametro = [self.messageParameters parametro:8];
        int dato;
        if (parametro)
            dato = [[self.messageParameters parametro:8] intValue];
        else
            dato = 7200;
        
        if (secondsBetween >= dato){
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"turn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (unitID>0 && ![[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.qflowRequest validarSedeParaActivarTurno:[_modelo.canalId intValue] processId:_modelo.internalCode];
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]){
    
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS20"];
        if (mensajeYParametros)
            [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Cerrar" otherBtn:@"Solicitar turno"];
        else
            [self message:@"Solicitar nuevo turno" messageDescription:@"De ser así, se cancelaría el turno que ya tienes reservado. Recuerda, solo es posible tener un turno a la vez." cancelBtn:@"Cerrar" otherBtn:@"Solicitar turno"];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1 && [[alertView buttonTitleAtIndex:buttonIndex]isEqual:@"Solicitar turno"]) {
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.qflowRequest cancelarTurno:[[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"ProcessId"] intValue]];
    }
}

-(void)turnoCancelado:(NSDictionary*)response{
    
    [self.hud hide:YES];
    
         if ([response[@"ReturnCode"] integerValue] == 0) {
        
             self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             [self.qflowRequest validarSedeParaActivarTurno:[_modelo.canalId intValue] processId:_modelo.internalCode];
         }else{
             NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
             if (mensajeYParametros)
                 [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
             else
                [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
     }
    
}

-(void)validaciondeSede:(BOOL)response{

    if (response){
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"turn"];
        
        [self.qflowRequest obtenerTurno:[_model[@"idQflowService"] intValue] customerId:[[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"] unitId:unitID];
    }
    else{
     
        [self.hud hide:YES];
        
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
        if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
        else
        [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
    }
}

-(void)turno:(NSDictionary*)response{
    
    [self.hud hide:YES];
    
    if (![response[@"objReturnValue"][@"ReturnCode"]boolValue]) {
     
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:response];
        [dic setObject:[NSDate date] forKey:@"dateXpiration"];
        [dic setObject:[NSNumber numberWithInt:tiempo] forKey:@"timeToLife"];
        [dic setObject:@0 forKey:@"activate"];
        [dic setObject:_modelo.nombreactual forKey:@"nameChannel"];
        [dic setObject:_modelo.nomenclatura forKey:@"locationChannel"];
        [dic setObject:[NSNumber numberWithInt:_modelo.internalCode] forKey:@"channelId"];
        [dic setObject:[NSNumber numberWithInt:unitID] forKey:@"unitId"];
        [dic setObject:_model forKey:@"serviceData"];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"turn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:^(void){
            [delegate getTurn:response];
        }];
    }else{
        
        [self close];
        
        NSString *messageQflowResponse = response[@"objReturnValue"][@"ReturnMessage"];
        
        if ([messageQflowResponse containsString:@"lista negra"]) {
            
            NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS29"];
            if (mensajeYParametros)
                [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
            else
                [self message:@"Información" messageDescription:@"En este momento no es posible solicitar turnos desde la app. Te recomendamos dirigirte a la sucursal mas cercana." cancelBtn:@"Aceptar" otherBtn:nil];
            
        }else{
        
            NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
            if (mensajeYParametros)
                [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
            else
                [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
        }
    
    }
}

-(void)imageTapped{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)qflowErrorRequest:(NSError*)error{

    [self.hud hide:YES];
    
    [self close];
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
    if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
    else
        [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
    
    [self imageTapped];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
