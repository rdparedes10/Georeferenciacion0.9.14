//
//  QflowTurnViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 27/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "QflowTurnViewController.h"
#import "QRViewController.h"
#import "Constantes.h"

@interface QflowTurnViewController (){
    
    NSTimer *searchDelayer;
    NSDate *horaDeConsulta;
    float tiempoDeVida;
}

@end

@implementation QflowTurnViewController

@synthesize hour,minute,_alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"";
    
    self.constant = [[Constantes alloc] init];
    
    self.qflowRequest.delegate = self;
    
    horaDeConsulta = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"dateXpiration"];
    tiempoDeVida = [[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"timeToLife"] floatValue];
    
    if (_showTurn && [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]) {
        
        _model = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"];
        _name.text = _model[@"nameChannel"];
        _location.text = _model[@"locationChannel"];
        _icon.image = [self.constant iconodeCanalConEfecto:[_model[@"channelId"] intValue]];
        
    }else{
        
        _name.text = _modelo.nombreactual;
        _location.text = _modelo.nomenclatura;
        _icon.image = [self.constant iconodeCanalConEfecto:[_modelo.canalId intValue]];
    }
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS12"];
    if (mensajeYParametros)
        _alertView._texto.text = mensajeYParametros[@"messageContent"];
    else
        _alertView._texto.text = @"Tu turno ha sido generado y reservado, una vez llegues a la oficina seleccionada actívalo para que puedas obtener el número de turno con el cual te atenderán.";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS13"];
    if (mensajeYParametros)
        _tiempoEstimadoTitulo.text = mensajeYParametros[@"messageContent"];
    else
        _tiempoEstimadoTitulo.text = @"Tiempo restante de espera:";
    
    mensajeYParametros = [self.messageParameters mensaje:@"MS14"];
    if (mensajeYParametros)
        _tituloControlScroll.text = mensajeYParametros[@"messageContent"];
    else
        _tituloControlScroll.text = @"Antes de activar tu turno, recuerda:";
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];

    [self tiempoRestante];
    searchDelayer = [NSTimer scheduledTimerWithTimeInterval:30
                                                     target:self
                                                   selector:@selector(tiempoRestante)
                                                   userInfo:nil
                                                    repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{

    [searchDelayer invalidate], searchDelayer=nil;
}

-(void)tiempoRestante{

    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:horaDeConsulta];
    
    if (secondsBetween<tiempoDeVida) {
        
        float tiempo = (float)(tiempoDeVida-secondsBetween);
        
        float horas = (float)tiempo/3600;
        float minutos = (horas-floorf(horas))*60;
        
        if (horas>=2 || horas < 1)
            hour.text = [NSString stringWithFormat:@"%d horas",(int)horas];
        else
            hour.text = [NSString stringWithFormat:@"%d Hora",(int)horas];
        
        if (minutos>=2 || minutos < 1)
            minute.text = [NSString stringWithFormat:@"%.0f minutos",minutos];
        else
            minute.text = [NSString stringWithFormat:@"%.0f minuto",minutos];
    
    }else{
    
        hour.text = @"0 horas";
        minute.text = @"0 minutos";
    }
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    
    float width = self.view.bounds.size.width;
    _width = width;
    
    _globalScrollView.contentSize = CGSizeMake(width, _activaTurnoBtn.frame.origin.y+50);
    _globalScrollView.layer.masksToBounds = YES;
    _scrollView.contentSize = CGSizeMake((width-30)*3,_scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    NSArray *mensajesDefecto = @[@"Trata de estar 5 minutos antes en la oficina seleccionada para que hagas la activación de tu turno.",@"Activa tu turno haciendo clic en el botón Activar turno y lee el código QR que está ubicado en la entrada de las oficinas.",@"Recuerda tener tu dispositivo con suficiente batería y conexión a internet, lo vas a necesitar para activar tu turno y verificar tu número de turno."];

    for (int i=0; i<3; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10+((width-30)*i), 40, 50, 50)];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"slideIcon%d",i]];
        img.image = [img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [img setTintColor:self.constant.colorPrecessBlack];
        [_scrollView addSubview:img];
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(70+((width-30)*i), 40, width-30-85, 55)];
        text.font = [UIFont fontWithName:@"Arimo" size:11.0];
        text.textAlignment = NSTextAlignmentCenter;
        text.lineBreakMode = NSLineBreakByWordWrapping;
        text.numberOfLines = 3;
        text.textColor = [UIColor colorWithRed:35.0/255.0 green:31.0/255.0 blue:32.0/255.0 alpha:0.8];
        
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:[NSString stringWithFormat:@"MS%d",15+i]];
        if (mensajeYParametros)
            text.text = mensajeYParametros[@"messageContent"];
        else{
            text.text = mensajesDefecto[i];
        }
        
        [_scrollView addSubview:text];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)activate {

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]) {
        
        NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"dateXpiration"];
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
        
        NSString *parametro = [self.messageParameters parametro:8];
        int dato;
        if (parametro)
            dato = [[self.messageParameters parametro:8] intValue];
        else
            dato = 7200;
        
        if (secondsBetween<dato){
            
            NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS18"];
            if (mensajeYParametros)
                [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Cerrar" otherBtn:@"Activar turno"];
            else
                [self message:@"Información" messageDescription:@"Activa tu turno haciendo clic en el botón Activar turno y lee el código QR que está ubicado en la entrada de las oficinas." cancelBtn:@"Cerrar" otherBtn:@"Activar turno"];
            
            //[qflowRequest activarTurno:[[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"unitId"] intValue] processId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"ProcessId"] intValue]];
        }
        else{
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"turn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (IBAction)cancel {
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS19"];
    if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Cerrar" otherBtn:@"Cancelar turno"];
    else
        [self message:@"Información" messageDescription:@"¿Estás seguro que deseas cancelar este turno?" cancelBtn:@"Cerrar" otherBtn:@"Cancelar turno"];
}

- (IBAction)pageControlTouch:(UIPageControl *)sender {
    
}

- (IBAction)openCloseScroll:(UIButton *)sender {
    
    if (_scrollHeight.constant == 128) {
        
        _scrollHeight.constant = 38;
        
        [UIView animateWithDuration:0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             _pageControl.alpha = 0;
                             [self.view layoutIfNeeded];
                             _globalScrollView.contentSize = CGSizeMake(_width, _activaTurnoBtn.frame.origin.y+50);
                         }
                         completion:^(BOOL finished){
                             
                             [__openCloseScroll setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];

                         }];
    }
    else if (_scrollHeight.constant == 38){
    
        _scrollHeight.constant = 128;
        
        [UIView animateWithDuration:0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             _pageControl.alpha = 1.0;
                             [self.view layoutIfNeeded];
                             _globalScrollView.contentSize = CGSizeMake(_width, _activaTurnoBtn.frame.origin.y+50);
                         }
                         completion:^(BOOL finished){
                             [__openCloseScroll setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
                         }];
    }
    
}

-(void)tiemposDeEspera:(NSDictionary*)response{
    
    CGFloat horas = [response[@"EstimatedWaitingTime"] intValue]/3600;
    CGFloat minutos = (horas-floorf(horas))*60;
    
    if (horas>=2 || horas < 1)
        hour.text = [NSString stringWithFormat:@"%.0f horas",horas];
    else
        hour.text = [NSString stringWithFormat:@"%.0f Hora",horas];
    
    if (minutos>=2 || minutos < 1)
        minute.text = [NSString stringWithFormat:@"%.0f minutos",minutos];
    else
        minute.text = [NSString stringWithFormat:@"%.0f minuto",minutos];
}

-(void)turnoCancelado:(NSDictionary*)response{

    [self.hud hide:YES];
   
        if ([response[@"ReturnCode"] integerValue] == 0) {
            
            [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Turno"
                                                                       action:@"Generado"
                                                                        label:@"Cancelado"
                                                                        value:@0] build]];
            
            [self.navigationController popViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"turn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
            if (mensajeYParametros)
                [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
            else
                [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1 && [[alertView buttonTitleAtIndex:buttonIndex]isEqual:@"Cancelar turno"]) {
     
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.qflowRequest cancelarTurno:[[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"ProcessId"] intValue]];
    }
    else if (buttonIndex == 1 && [[alertView buttonTitleAtIndex:buttonIndex]isEqual:@"Activar turno"]) {
    
        QRViewController *vc = [[QRViewController alloc] initWithNibName:@"QRViewController" bundle:nil];
        
        vc.uniqueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"unitId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)qflowErrorRequest:(NSError*)error{

    [self.hud hide:YES];
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
    if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
    else
        [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
}

@end
