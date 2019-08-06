//
//  MapViewController.m
//  Georeferenciacion
//
//  Created by Armando Restrepo on 4/20/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "MapViewController.h"
#import "SelectServiceViewController.h"
#import "QflowTurnViewController.h"
#import "TurnViewController.h"
#import "Constantes.h"

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

@interface MapViewController () {

    FilterViewController *filterResponse;
    Modelo *modeloEnviadoAHorarios;
    Modelo *modeloDestinodeRuta;
    searchGoogleViewController *searchWords;
    NSDate *dateCharge;
    NSString *tipoDeCanal;
    CLLocationDegrees lati;
    CLLocationDegrees lngi;
}

@end

@implementation MapViewController

@synthesize scheduleViewController,mapView_,serviciosText,botonQflow,labelQflow;

NSMutableDictionary *filterParameters;
int idCanalPorDefecto;
int selectedChannelIndex = 0;
float width;
float heightDetailView;
int route; //1 Car - 2 Walking
Constantes *constantsMapView;

- (void)viewWillAppear:(BOOL)animated{
    
    constantsMapView = [[Constantes alloc] init];
    [self.tracker set:kGAIScreenName value:@"Buscador"];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
    } else {
        [self message:@"Información" messageDescription:@"No es posible obtener tu ubicación. Verifica si se tiene habilitada esta configuración" cancelBtn:@"Aceptar" otherBtn:nil];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]) {
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"couchMarks"][@"mark1"] boolValue]) {
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"couchMarks"]];
            
            dic[@"mark1"] = @1;
            
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"couchMarks"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            self.vc.width = width;
            self.vc.height = self.view.frame.size.height;
            self.vc.imagenesDeAyuda = @[@"Coachmark6.jpg"];
            [self presentViewController:self.vc animated:YES completion:nil];
        }
        
        _turn.hidden = NO;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"activate"] intValue] == 1) {
            [_turn setImage:[UIImage imageNamed:@"turnYellow"] forState:UIControlStateNormal];
        }
        else {
            
            NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"dateXpiration"];
            NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
            
            NSString *parametro = [self.messageParameters parametro:8];
            int dato;
            if (parametro)
                dato = [[self.messageParameters parametro:8] intValue];
            else
                dato = 7200;
        
            if (secondsBetween<dato) {
                [_turn setImage:[UIImage imageNamed:@"turnBlue"] forState:UIControlStateNormal];
            }
            else if (secondsBetween>=dato) {
                [_turn setImage:[UIImage imageNamed:@"turnRed"] forState:UIControlStateNormal];
            }
        }
    }
    else
        _turn.hidden = YES;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        botonQflow.hidden = YES;
        labelQflow.hidden = YES;
        
        _turnList.enabled = false;
        
        self.navigationController.navigationBar.barTintColor = self.constant.colorBlue;
        self.navigationController.navigationBar.translucent = NO;
        
        _turnListH.constant = 0;
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    lati = 0;
    lngi = 0;
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    modeloEnviadoAHorarios = [[Modelo alloc] init];
    modeloDestinodeRuta = [[Modelo alloc] init];
    
    filterResponse = [[FilterViewController alloc] init];
    filterResponse.delegate = self;
    tipoDeCanal = @"";
    
    searchWords = [[searchGoogleViewController alloc] init];
    searchWords.delegate = self;
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        self.navigationController.navigationBar.barTintColor = self.constant.colorBlue;
        self.navigationController.navigationBar.translucent = NO;
        _turnListH.constant = 0;
        
        UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = flipButton;
    }
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchWhite"] style:UIBarButtonItemStylePlain target:self action:@selector(searchView)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
    filterParameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"latitude":[NSNumber numberWithFloat:lati],@"longitude":[NSNumber numberWithFloat:lngi],@"idType":@"",@"radioInKms":@"",@"filterProperties":[[NSMutableArray alloc] init],@"userLatitude":@6.150833,@"userLongitude":@-75.615}];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]) {
    
        [[NSUserDefaults standardUserDefaults] setObject:[self.constant uuid] forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    width = self.view.frame.size.width;
    heightDetailView = _botonRuta.frame.origin.y+_botonRuta.frame.size.height+35;
    
    self.request.delegate = self;
    [self.request consultarCanales];
    
    self.channelsArray = [[NSMutableArray alloc] init];
    _sedesArray = [[NSMutableArray alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"canales"] && [(NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"canales"] count] > 0) {
        
        self.channelsArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"canales"];
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0"))
        [_locationManager requestWhenInUseAuthorization];
    //_locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
//    _locationManager.pausesLocationUpdatesAutomatically = YES;
//    _locationManager.activityType = CLActivityTypeFitness;
    //_locationManager.allowsBackgroundLocationUpdates = YES;
    [_locationManager startMonitoringSignificantLocationChanges];
    //[_locationManager startUpdatingLocation];
    _startLocation = nil;
    
    UIView *view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MapViewController" owner:self options:nil] firstObject];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:3.606219
                                                            longitude:-73.271030
                                                                 zoom:6];
    mapView_.camera = camera;
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.delegate = self;
    
    self.view = view;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _filterView.tabla.delegate = self;
    _filterView.tabla.dataSource = self;
    
    _infoView.layer.masksToBounds = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_infoView addGestureRecognizer:pan];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"couchMarks"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@{@"mark0":@0,@"mark1":@0,@"mark2":@0} forKey:@"couchMarks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            self.vc.imagenesDeAyuda = @[@"Coachmark7.jpg",@"Coachmark8.jpg"];
        }
        else {
            self.vc.imagenesDeAyuda = @[@"Coachmark1.jpg"];
        }
        
        self.vc.width = width;
        self.vc.height = self.view.frame.size.height;
        [self presentViewController:self.vc animated:YES completion:nil];
    }
}

-(void)viewWillLayoutSubviews{
    
    width = self.view.frame.size.width;
    heightDetailView = _botonRuta.frame.origin.y+_botonRuta.frame.size.height+35;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    // Adding the swipe gesture on image view
    [self.filtrosView addGestureRecognizer:swipeLeft];
    [self.filtrosView addGestureRecognizer:swipeRight];
    
    [self.request Reachability];
    
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)openTurn{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]) {        
        
        if ([self isTurnExpired]){
            NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS21"];
            if (mensajeYParametros)
                [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
            else
                [self message:@"Tu turno ha expirado" messageDescription:@"Tu turno ya no está vigente, pues se ha pasado el tiempo para activarlo en la oficina." cancelBtn:@"Aceptar" otherBtn:nil];
            
                _turn.hidden = YES;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"turn"];
                [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"activate"] intValue] == 1){
                TurnViewController *vc = [[TurnViewController alloc] initWithNibName:@"TurnViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                QflowTurnViewController *vc = [[QflowTurnViewController alloc] initWithNibName:@"QflowTurnViewController" bundle:nil];
                vc.showTurn = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                   
        }

    }
    else{
    
        _turn.hidden = YES;
    }

}

-(BOOL) isTurnExpired{

    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"dateXpiration"];
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:date];
    
    NSString *parametro = [self.messageParameters parametro:8];
    int dato;
    if (parametro)
        dato = [[self.messageParameters parametro:8] intValue];
    else
        dato = 7200;
    
    if (secondsBetween < dato){
        return false;
    }
    return true;
}

-(void)returObjectSelectedCell:(Modelo *)model{
    
    [mapView_ clear];
    
    [_botonUpDown setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(model.latitud, model.longitud);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.title = model.nombreactual;
    marker.snippet = model.nomenclatura;
    marker.icon = [self.constant pindeCanal:[model.canalId intValue]];
    marker.userData = @{@"marker_id":[NSNumber numberWithInt:model.idInterno]};
    //marker.icon = [UIImage imageNamed:@"flag_icon"];
    
    if (!model.oficinaAbierta) {
        marker.icon = [UIImage imageNamed:@"pinOff"];
    }
    
    marker.map = mapView_;
    
    modeloEnviadoAHorarios = model;
    _nombreLabel.text = model.nombreactual;
    _direccionLabel.text = model.nomenclatura;
    _distanciaLabel.text = model.distancia;
    _horarioLabel.text = model.cierraEn;
    _telefonoLabel.text = model.telefono;
    serviciosText.text =@"";
    
    for (int i = 0; i < [model.servicios count]; i++) {
        
        if (i == 0) {
            
            serviciosText.text = [NSString stringWithFormat:@"⋅ %@",[model.servicios objectAtIndex:i][@"serviceName"]];
        }
        else{
            
            serviciosText.text = [NSString stringWithFormat:@"%@\n⋅ %@",serviciosText.text,[model.servicios objectAtIndex:i][@"serviceName"]];
        }
        
    }
    
    float phoneHeight = 22;
    float scheduleHeight = 22;
    
    if ([model.cierraEn isEqualToString:@""])
    scheduleHeight = 0;
    
    if ([model.telefono isEqualToString:@""])
    phoneHeight = 0;
    
    botonQflow.enabled = model.oficinaAbierta;
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self hidePhoneAndSchedule:_telefonoViewDetailHeight phoneFloatHeight:phoneHeight schedule:_horarioViewDetailHeight scheduleFloatHeight:scheduleHeight specialServices:[model.servicios count] schedule:[model.horarios count] qflow:model.qflow];
    });
    
    [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:model.latitud
                                                                  longitude:model.longitud
                                                                       zoom:15]];
    
    _ruta = nil;
    
}

-(void)respuestaDelFiltro:(NSMutableArray*)canales{
    
    [self sedes:canales];
}

-(IBAction)openQflowSelectService{
    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:dateCharge];
    
    NSString *parametro = [self.messageParameters parametro:7];
    int dato;
    if (parametro)
        dato = [[self.messageParameters parametro:7] intValue];
    else
        dato = 1800;
    
    if (modeloEnviadoAHorarios.secondsToClose-secondsBetween>dato){
    
        SelectServiceViewController *vc = [[SelectServiceViewController alloc] initWithNibName:@"SelectServiceViewController" bundle:nil];
        vc.model = modeloEnviadoAHorarios;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
    
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS05"];
        if (mensajeYParametros)
            [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
        else
            [self message:@"Información" messageDescription:@"Ten en cuenta que puedes solicitar un turno hasta 30 minutos antes del cierre de la oficina." cancelBtn:@"Aceptar" otherBtn:nil];
    }
}

-(IBAction)openDetailHour{
    
    scheduleViewController = [[ScheduleViewController alloc] initWithNibName:@"ScheduleViewController" bundle:nil];
    scheduleViewController.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    scheduleViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    scheduleViewController.modelo = modeloEnviadoAHorarios;
    [self presentViewController:scheduleViewController animated:YES completion:nil];
    
}

bool animationState; //Variable que controla el estado de los filtros laterales (Canales Activos, Turnos y Ayuda)
bool animationStateChannels;

bool animationStateDetail;

float directionY = 0;

bool stateFilterOpenChannels;

- (IBAction)filtrarPorEstado {
    
    [mapView_ clear];
    
    if (!stateFilterOpenChannels) {
     
        stateFilterOpenChannels = YES;
        
        for (int i = 0; i<_sedesArray.count; i++) {
            
            Modelo *modelo = [[Modelo alloc] init];
            modelo = [_sedesArray objectAtIndex:i];
            
            if (modelo.oficinaAbierta) {
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(modelo.latitud, modelo.longitud);
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.icon = [self.constant pindeCanal:[modelo.canalId intValue]];
                marker.title = modelo.nombreactual;
                marker.snippet = modelo.nomenclatura;
                marker.userData = @{@"marker_id":[NSNumber numberWithInt:i]};
                marker.map = mapView_;
            }
        }
    }
    else{
        
        stateFilterOpenChannels = NO;
        
        for (int i = 0; i<_sedesArray.count; i++) {
            
            Modelo *modelo = [[Modelo alloc] init];
            modelo = [_sedesArray objectAtIndex:i];
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(modelo.latitud, modelo.longitud);
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.icon = [self.constant pindeCanal:[modelo.canalId intValue]];
            marker.title = modelo.nombreactual;
            marker.snippet = modelo.nomenclatura;
            marker.userData = @{@"marker_id":[NSNumber numberWithInt:i]};
            
            if (!modelo.oficinaAbierta)
                marker.icon = [UIImage imageNamed:@"pinOff"];
            //marker.icon = [UIImage imageNamed:@"flag_icon"];
            marker.map = mapView_;
            
            idCanalPorDefecto = [modelo.canalId intValue];
        }
    }
    
}

-(IBAction)openDetail{

    if (_heightInfoView.constant < heightDetailView && !animationStateDetail) {
        
        animationStateDetail = YES;
        
        if (_heightFilterView.constant!=0)
            _heightFilterView.constant = 0;
        
        _heightInfoView.constant = heightDetailView;
        [UIView animateWithDuration:0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
                             [_botonUpDown setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
                             animationStateDetail = NO;
                             
                         }];
    }
    else if (!animationStateDetail){
    
        animationStateDetail = YES;
        _heightInfoView.constant = 25;
        [UIView animateWithDuration:0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
                             [_botonUpDown setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
                             animationStateDetail = NO;
                             
                         }];
    }
}

-(void)handlePan:(UIGestureRecognizer*)panGes{
    
    CGPoint point = [panGes locationInView:self.view];
    
    if (point.y > 25 && point.y < heightDetailView) {
        _heightInfoView.constant = point.y;
    }
    
    if(panGes.state == UIGestureRecognizerStateEnded)
    {
        float auxY = directionY-point.y;
        
        if (auxY < 0 && fabsf(auxY)> 5) {
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    if (_heightFilterView.constant!=0)
                        _heightFilterView.constant = 0;
                    
                    _heightInfoView.constant = heightDetailView;
                    [UIView animateWithDuration:0.25
                                          delay: 0.0
                                        options: UIViewAnimationOptionCurveLinear
                                     animations:^{
                                         
                                         [self.view layoutIfNeeded];
                                     }
                                     completion:^(BOOL finished){
                                         
                                         [_botonUpDown setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
                                     }];
                });
            });
            
        }
        else{
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    _heightInfoView.constant = 25;
                    [UIView animateWithDuration:0.25
                                          delay: 0.0
                                        options: UIViewAnimationOptionCurveLinear
                                     animations:^{
                                         
                                         [self.view layoutIfNeeded];
                                     }
                                     completion:^(BOOL finished){
                                         
                                         [_botonUpDown setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
                                     }];
                });
            });
        
        }
        
        directionY = point.y;
    }
    
}

- (IBAction)openLayar{

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"layar://bancolombiagj33f"]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"layar://bancolombiagj33f?action=update&idChannelType=%d",idCanalPorDefecto]]];
    }
    else{
    
        [self message:@"Instalar Layar" messageDescription:@"Al parecer no tienes instalado Layar, descargalo gratis en el App Store." cancelBtn:@"Cancelar" otherBtn:@"Ver en el App Store"]; 
    }
}

- (IBAction)openList {
    
    ListViewController *vc =  [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    vc.canales = _sedesArray;
    vc.dateCharge = dateCharge;
    vc.delegate = self;
    vc.name = [self.channelsArray objectAtIndex:[self getChannelTypePosition:idCanalPorDefecto]][@"channelTypeName"];
    vc.hideTitle = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)openHelp
{
    if (!([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)) {
        self.vc.imagenesDeAyuda = @[@"Coachmark7.jpg",@"Coachmark8.jpg",@"Coachmark2.jpg",@"Coachmark4.jpg",@"Coachmark9.jpg",@"Coachmark6.jpg"];
    }
    else {
        self.vc.imagenesDeAyuda = @[@"Coachmark7.jpg",@"Coachmark8.jpg"];
    }
    
    self.vc.width = width;
    self.vc.height = self.view.frame.size.height;
    [self presentViewController:self.vc animated:YES completion:nil];
}

- (IBAction)turnListAction{
    
    ListViewController *vc =  [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    vc.dateCharge = dateCharge;
    vc.setCanalesArray = _sedesArray;
    vc.turnFilter = YES;
    vc.name = [self.channelsArray objectAtIndex:[self getChannelTypePosition:idCanalPorDefecto]][@"channelTypeName"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)openChannels{
    
    int dinamicHeight = [self.channelsArray count] * 44;
    if (184 < dinamicHeight){
        dinamicHeight = 184;
    }
    
    if (_heightFilterView.constant == dinamicHeight && !animationStateChannels) {
        
        animationStateChannels=YES;
        _heightFilterView.constant = 0;
        
        [UIView animateWithDuration:0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
                             animationStateChannels=NO;
                             
                         }];
        
    }else if(!animationStateChannels){
        
        animationStateChannels=YES;
        
        if (_heightInfoView.constant!=0)
            _heightInfoView.constant = 25;
        
        _heightFilterView.constant = dinamicHeight;
        
        [UIView animateWithDuration:0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
                             [_botonUpDown setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
                             animationStateChannels=NO;
                             
                         }];
        
    }
    
}

-(IBAction)openFilter{
    
    if (_trailingFilterView.constant == 0 && !animationState) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            animationState=YES;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                _trailingFilterView.constant = -44;
                [UIView animateWithDuration:0.25
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     
                                     [_botonLeftRight setImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
                                     animationState=NO;
                                     
                                 }];
            });
        });
        
    }
    else if (!animationState){
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            animationState=YES;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                _trailingFilterView.constant = 0;
                [UIView animateWithDuration:0.25
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     [_botonLeftRight setImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
                                     animationState=NO;
                                     
                                 }];
            });
        });
    }
}

-(IBAction)openFilters{
    
    NSArray *filterArray = [self.channelsArray objectAtIndex:[self getChannelTypePosition:idCanalPorDefecto]][@"filterCategories"];
    
    if(filterArray.count>0) {
        
        FilterViewController *vc =  [[FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
        vc.filterarray = [self.channelsArray objectAtIndex:[self getChannelTypePosition:idCanalPorDefecto]][@"filterCategories"];
        vc.channelId = [NSNumber numberWithInt:[self getChannelTypePosition:idCanalPorDefecto]];
        vc.name = [self.channelsArray objectAtIndex:[self getChannelTypePosition:idCanalPorDefecto]][@"channelTypeName"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        //[self presentViewController:vc animated:YES completion:nil];
    }
}

-(IBAction)llamar{

    if ([self validandoTelefono:modeloEnviadoAHorarios.telefono]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",modeloEnviadoAHorarios.telefono]]];
    }
}

-(int)getChannelTypePosition:(int) channelType{

    for (int i = 0; i < self.channelsArray.count ; i++) {
        
        if ([self.channelsArray[i][@"idChannelType"] intValue] == channelType) {
            return i;
        }
    }
    
    return 0;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft && !animationState) {
        NSLog(@"Left Swipe");
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            animationState=YES;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                _trailingFilterView.constant = 0;
                [UIView animateWithDuration:0.25
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     
                                     [_botonLeftRight setImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
                                     animationState=NO;
                                     
                                 }];
            });
        });
        
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight && !animationState) {
        NSLog(@"Right Swipe");
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            animationState=YES;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                _trailingFilterView.constant = -44;
                [UIView animateWithDuration:0.25
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     
                                     [self.view layoutIfNeeded];
                                 }
                                 completion:^(BOOL finished){
                                     [_botonLeftRight setImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
                                     animationState=NO;
                                     
                                 }];
            });
        });
    }
}

-(IBAction)ruta:(id)sender{
    
    modeloDestinodeRuta = [[Modelo alloc] init];
    modeloDestinodeRuta = modeloEnviadoAHorarios;

    route = [sender tag];
    
    switch ([sender tag]) {
        
        case 1:
            
            [self.request crearRuta:_locationManager.location.coordinate.latitude lngOrigen:_locationManager.location.coordinate.longitude latDestino:modeloDestinodeRuta.latitud lngDestino:modeloDestinodeRuta.longitud tipoDeRuta:@"driving"];
            break;
            
        case 2:

            [self.request crearRuta:_locationManager.location.coordinate.latitude lngOrigen:_locationManager.location.coordinate.longitude latDestino:modeloDestinodeRuta.latitud lngDestino:modeloDestinodeRuta.longitud tipoDeRuta:@"walking"];
            break;
    }
}

-(void)searchView{

    searchGoogleViewController *vc =  [[searchGoogleViewController alloc] initWithNibName:@"searchGoogleViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)findLocation:(CLLocationCoordinate2D)coordinate{
    
    [self.hud show:YES];
    
    [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:coordinate.latitude
                                                                  longitude:coordinate.longitude
                                                                       zoom:14.5]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1 && [[alertView buttonTitleAtIndex:buttonIndex]isEqual:@"Ver en App Store"]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/co/VPP7t.i"]];
    }
}

#pragma mark QflowRequest

-(void)registerActivateLogin:(NSDictionary*)response{
    
    [[NSUserDefaults standardUserDefaults] setObject:response[@"CustomerId"] forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"%@ - %@",response,[[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"]);
}

-(void)qflowErrorRequest:(NSError*)error{
    
    [self.hud hide:YES];
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
    if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
    else
        [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
}

#pragma mark GeoLocationDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    [filterParameters setObject:[NSNumber numberWithFloat:newLocation.coordinate.latitude] forKey:@"userLatitude"];
    [filterParameters setObject:[NSNumber numberWithFloat:newLocation.coordinate.longitude] forKey:@"userLongitude"];
    
    if (lati == 0 && lngi == 0) {
        
        lati = newLocation.coordinate.latitude;
        lngi = newLocation.coordinate.longitude;
        
        filterParameters[@"latitude"] = [NSNumber numberWithFloat:lati];
        filterParameters[@"longitude"] = [NSNumber numberWithFloat:lngi];
        
        [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                      longitude:newLocation.coordinate.longitude
                                                                           zoom:14.5]];
        
        //[request cononectarServicio:tipoDeCanal Latitud:newLocation.coordinate.latitude longitud:newLocation.coordinate.longitude radio:1];
        [self.request filtrarCanales: filterParameters];
    }
    
    oldLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    if ([newLocation distanceFromLocation:oldLocation] > 200) {
        
        [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                                      longitude:newLocation.coordinate.longitude
                                                                           zoom:14.5]];
        
        //[request cononectarServicio:tipoDeCanal Latitud:newLocation.coordinate.latitude longitud:newLocation.coordinate.longitude radio:1];
    }
}

-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            
            NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS02"];
            if (mensajeYParametros)
                [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
            else
                [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
        }
    }
    
}

#pragma mark tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.channelsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UIImageView *icon;
    UILabel *channel;
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 36, 36)];
        icon.tag = 1;
        icon.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:icon];
        
        channel = [[UILabel alloc] initWithFrame:CGRectMake(49, 13, cell.frame.size.width-49, 20)];
        channel.tag = 2;
        channel.font = [UIFont fontWithName:@"Arimo" size:15.0];
        channel.textColor = self.constant.colorPrecessBlack;
        
        if (idCanalPorDefecto == [[self.channelsArray objectAtIndex:indexPath.row][@"idChannelType"] intValue]){
            channel.textColor = self.constant.colorBlue;
            [tableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        }
        
        [cell.contentView addSubview:channel];
    }
    else{
        
        icon = (UIImageView *)[cell.contentView viewWithTag:1];
        channel = (UILabel *)[cell.contentView viewWithTag:2];
    }

    channel.text = [self.channelsArray objectAtIndex:indexPath.row][@"channelTypeName"];
    NSString *imageName = [self.channelsArray objectAtIndex:indexPath.row][@"imageFilter"];
    icon.image = [UIImage imageNamed:[imageName stringByReplacingOccurrencesOfString:@".png" withString:@""]];
    
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width+1000, 0.f, 0.f);
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tipoDeCanal = [self.channelsArray objectAtIndex:indexPath.row][@"idChannelType"];
    selectedChannelIndex = [tipoDeCanal intValue];
    if (idCanalPorDefecto != [tipoDeCanal intValue]) {
        
        _ruta = nil;
        animationStateDetail = YES;
        _heightInfoView.constant = 0;
        [UIView animateWithDuration:0.25
                              delay: 0.0
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
                             animationStateDetail = NO;
                             
                         }];
    }
    
    idCanalPorDefecto = [tipoDeCanal intValue];
    [self colorTableViewCell:tableView didSelectRowAtIndexPath:indexPath];
    
    filterParameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"latitude":[NSNumber numberWithFloat:lati],@"longitude":[NSNumber numberWithFloat:lngi],@"idType":tipoDeCanal,@"radioInKms":@"",@"filterProperties":[[NSMutableArray alloc] init],@"userLatitude":[NSNumber numberWithFloat: _locationManager.location.coordinate.latitude],@"userLongitude":[NSNumber numberWithFloat: _locationManager.location.coordinate.longitude]}];
    
    
    [self.request filtrarCanales:filterParameters];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:lati
                                                                  longitude:lngi
                                                                       zoom:14]];
    [self.hud show:YES];
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Canal"
                                                               action:@"Seleccionado"
                                                                label:[self.channelsArray objectAtIndex:indexPath.row][@"channelTypeName"]
                                                                value:nil] build]];
    
    
    if ([tipoDeCanal intValue] == 1){
        _turnList.enabled = YES;
        botonQflow.alpha = 1;
        labelQflow.alpha = 1;
    }
    else{
        _turnList.enabled = NO;
        botonQflow.alpha = 0;
        labelQflow.alpha = 0;
    }
    _channelLabel.text =  [self.channelsArray objectAtIndex:indexPath.row][@"channelTypeName"];
    
    _ruta = nil;
    modeloDestinodeRuta = nil;
}

- (void)colorTableViewCell:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *channel = (UILabel *)[cell.contentView viewWithTag:2];
    
    for (int i = 0; i < [self.channelsArray count]; i++) {
        
        UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UILabel *channel2 = (UILabel *)[cell2.contentView viewWithTag:2];
        
        if (i == indexPath.row) {
            
            channel.textColor = self.constant.colorBlue;
        }
        else{
        
            channel2.textColor = self.constant.colorPrecessBlack;
        }
    }
}

#pragma mark GoogleMaps

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    
    Modelo *model = [[Modelo alloc] init];
    model = [self.sedesArray objectAtIndex:[marker.userData[@"marker_id"] intValue]];
    modeloEnviadoAHorarios = model;
    _nombreLabel.text = marker.title;
    _direccionLabel.text = model.nomenclatura;
    _distanciaLabel.text = model.distancia;
    _horarioLabel.text = model.cierraEn;
    _telefonoLabel.text = model.telefono;
    
    serviciosText.text =@"";
    
    for (int i = 0; i < [model.servicios count]; i++) {
        
        if (i == 0) {
        
            serviciosText.text = [NSString stringWithFormat:@"⋅ %@",[model.servicios objectAtIndex:i][@"serviceName"]];
        }
        else{
        
            serviciosText.text = [NSString stringWithFormat:@"%@\n⋅ %@",serviciosText.text,[model.servicios objectAtIndex:i][@"serviceName"]];
        }
        
    }
    
    float phoneHeight = 22;
    float scheduleHeight = 22;
    
    if ([model.cierraEn isEqualToString:@""])
        scheduleHeight = 0;
    
    if ([model.telefono isEqualToString:@""])
        phoneHeight = 0;
    
    botonQflow.enabled = model.oficinaAbierta;
    
    [self hidePhoneAndSchedule:_telefonoViewDetailHeight phoneFloatHeight:phoneHeight schedule:_horarioViewDetailHeight scheduleFloatHeight:scheduleHeight specialServices:[model.servicios count] schedule:[model.horarios count] qflow:model.qflow];
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    
//    if (lati == 0 && lngi == 0) {
//        
//        lati = position.target.latitude;
//        lngi = position.target.longitude;
//        
//        filterParameters[@"latitude"] = [NSNumber numberWithFloat:lati];
//        filterParameters[@"longitude"] = [NSNumber numberWithFloat:lngi];
//        
//        //[request cononectarServicio:tipoDeCanal Latitud:latMoveMap longitud:lngMoveMap radio:1];
//    }

    CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:lati longitude:lngi];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:position.target.latitude longitude:position.target.longitude];
    
    if ([newLocation distanceFromLocation:oldLocation] > 1000 && lati && lngi) {
        
        lati = position.target.latitude;
        lngi = position.target.longitude;
        
        filterParameters[@"latitude"] = [NSNumber numberWithFloat:lati];
        filterParameters[@"longitude"] = [NSNumber numberWithFloat:lngi];
        
        //[request cononectarServicio:tipoDeCanal Latitud:newLocation.coordinate.latitude longitud:newLocation.coordinate.longitude radio:1];
        [self.request filtrarCanales: filterParameters];
    }
}

-(void)hidePhoneAndSchedule:(NSLayoutConstraint *)phoneConstraintHeight phoneFloatHeight:(float)phoneHeight schedule:(NSLayoutConstraint *)scheduleConstraintHeight scheduleFloatHeight:(float)scheduleHeight specialServices:(NSUInteger)specialServices schedule:(NSUInteger)scheduleActive qflow:(BOOL)qflowState{

    if(specialServices>0){
        
        if (specialServices>=3)
            _horariosEspecialesHeight.constant = 20*specialServices;
        else
            _horariosEspecialesHeight.constant = 40;
        
        _tituloHorariosEspecialesHeight.constant = 17;
    }
    else{
        
        _horariosEspecialesHeight.constant = 0;
        _tituloHorariosEspecialesHeight.constant = 0;
    }
    
    if (scheduleActive>0) {
        _scheduleLading.constant = 0;
    }
    else{
        
        _scheduleLading.constant = -_botonHorario.bounds.size.width;
    }
    
    phoneConstraintHeight.constant = phoneHeight;
    scheduleConstraintHeight.constant = scheduleHeight;
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         botonQflow.alpha = qflowState;
                         labelQflow.alpha = qflowState;
                         _iconPhoneViewDeatil.alpha = phoneHeight/22;
                         _iconScheduleViewDeatil.alpha = scheduleHeight/22;
                         
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         
                         if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"couchMarks"][@"mark0"] boolValue] && [[UIDevice currentDevice]userInterfaceIdiom]!=UIUserInterfaceIdiomPad) {
                             
                             NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"couchMarks"]];
                             
                             dic[@"mark0"] = @1;
                             
                             [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"couchMarks"];
                             [[NSUserDefaults standardUserDefaults] synchronize];

                             self.vc.width = width;
                             self.vc.height = self.view.frame.size.height;
                             self.vc.imagenesDeAyuda = @[@"Coachmark2.jpg"];
                             [self presentViewController:self.vc animated:YES completion:nil];
                         }
                         
                     }];
    
    heightDetailView = _botonRuta.frame.origin.y+_botonRuta.frame.size.height+35;
    _heightInfoView.constant = heightDetailView;
    
    [UIView animateWithDuration:0.25
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                        
                         [_botonUpDown setImage:[UIImage imageNamed:@"arrowUp"] forState:UIControlStateNormal];
                     }];
    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:dateCharge];
    
    NSString *parametro = [self.messageParameters parametro:7];
    int dato;
    if (parametro)
        dato = [[self.messageParameters parametro:7] intValue];
    else
        dato = 1800;
    
    if(([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad || modeloEnviadoAHorarios.secondsToClose-secondsBetween<=dato) && qflowState)
    {
        botonQflow.enabled = NO;
        botonQflow.alpha = 1;
        labelQflow.alpha = .4;
        _turnList.enabled = false;
    }
    
}

#pragma mark Repositorio Intergrupo

-(void)Reachability:(int)status{

    if (status > 0) {
        [_locationManager startUpdatingLocation];
    }
    else{
    
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS01"];
        if (mensajeYParametros)
            [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
        else
            [self message:@"Bancolombia" messageDescription:@"No es posible acceder a esta opción. Revisa tu conexión a internet." cancelBtn:@"Aceptar" otherBtn:nil];
    }
}

-(void)sedes:(NSMutableArray *)sedes{

    stateFilterOpenChannels = NO;
    
    if ([sedes count]>0 && _heightFilterView.constant != 0){
    
        [self openChannels];
    }
    
    _sedesArray = [[NSMutableArray alloc] initWithArray:sedes];
    [mapView_ clear];
    dateCharge = [NSDate date];
    
    [self.hud hide:YES];
    
    if (_ruta) {
    
        [_sedesArray addObject:modeloDestinodeRuta];
        
        GMSPolyline *rout = [GMSPolyline polylineWithPath:_ruta];
        rout.strokeWidth = 1.5;
        if (route==1)
            rout.strokeColor = self.constant.colorBlue;
        else{
            
            NSArray *styles = @[[GMSStrokeStyle solidColor:self.constant.colorBlue],
                                [GMSStrokeStyle solidColor:[UIColor clearColor]]];
            NSArray *lengths = @[@25, @20];
            rout.spans = GMSStyleSpans(rout.path, styles, lengths, kGMSLengthRhumb);
        }
        rout.map = mapView_;
    }
    
    for (int i = 0; i<_sedesArray.count; i++) {
        
        Modelo *modelo = [[Modelo alloc] init];
        modelo = [_sedesArray objectAtIndex:i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(modelo.latitud, modelo.longitud);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        _iconViewDeatil.image = [self.constant iconodeCanalConEfecto:[modelo.canalId intValue]];
        marker.title = modelo.nombreactual;
        marker.snippet = modelo.nomenclatura;
        marker.userData = @{@"marker_id":[NSNumber numberWithInt:i]};
        marker.icon = [self.constant pindeCanal:[modelo.canalId intValue]];
        
        if (!modelo.oficinaAbierta)
            marker.icon = [UIImage imageNamed:@"pinOff"];
        
        //marker.icon = [UIImage imageNamed:@"flag_icon"];
        marker.map = mapView_;
        
        if (idCanalPorDefecto != [modelo.canalId intValue]) {
            
            _ruta = nil;
            animationStateDetail = YES;
            _heightInfoView.constant = 0;
            [UIView animateWithDuration:0.25
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 [self.view layoutIfNeeded];
                             }
                             completion:^(BOOL finished){
                                 
                                 animationStateDetail = NO;
                                 
                             }];
        }
        
        idCanalPorDefecto = [modelo.canalId intValue];
    }
    
    selectedChannelIndex = idCanalPorDefecto;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"]) {
     
        QflowRequest *requestQflow = [[QflowRequest alloc] init];
        requestQflow.delegate = self;
        [requestQflow registerActivateLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    }
    
//    for (int i = 0; i<_channelsArray.count; i++) {
//        if ([[self.channelsArray objectAtIndex:i][@"idChannelType"] intValue] == idCanalPorDefecto)
//            _channelLabel.text =  [self.channelsArray objectAtIndex:i][@"channelTypeName"];
//    }
    
    if (idCanalPorDefecto == 1)
        _turnList.enabled = YES;
    else
        _turnList.enabled = NO;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.idChannelType==%d", idCanalPorDefecto];
    NSArray *results = [self.channelsArray filteredArrayUsingPredicate:predicate];
    if(results.count > 0){
        _channelLabel.text = [results firstObject][@"channelTypeName"];
    }
}

-(void)canales:(NSMutableArray *)canales{
    NSLog(@"%@",canales);
    self.channelsArray = canales;
    [_filterView.tabla reloadData];
    _channelLabel.text =  [self.channelsArray objectAtIndex:0][@"channelTypeName"];
    [self.request consultarMensajesParametrizables];
}

-(void)parametrosYmensajes:(NSMutableDictionary *)parametrosYmensajes{

    NSLog(@"%@",parametrosYmensajes);
}

-(void)movimientoEnMapa:(NSMutableArray *)canalesEncontrados{

    stateFilterOpenChannels = NO;
    
    if ([canalesEncontrados count]>0 && _heightFilterView.constant != 0)
        [self openChannels];
    
    [self.hud hide:YES];
    
    NSUInteger Aux = _sedesArray.count;
    
    if (_sedesArray.count>0) {
     
        [_sedesArray addObjectsFromArray:canalesEncontrados];
    }
    else{
    
        _sedesArray = [[NSMutableArray alloc] initWithArray:canalesEncontrados];
    }
    
    for (int i = 0; i<canalesEncontrados.count; i++) {
        
        NSLog(@"id %d",(int)Aux+i);
        
        Modelo *modelo = [[Modelo alloc] init];
        modelo = [canalesEncontrados objectAtIndex:i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(modelo.latitud, modelo.longitud);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        _iconViewDeatil.image = [self.constant iconodeCanalConEfecto:[modelo.canalId intValue]];
        marker.title = modelo.nombreactual;
        marker.snippet = modelo.nomenclatura;
        marker.userData = @{@"marker_id":[NSNumber numberWithInt:(int)Aux+i]};
        marker.icon = [self.constant pindeCanal:[modelo.canalId intValue]];
        
        if (!modelo.oficinaAbierta)
            marker.icon = [UIImage imageNamed:@"pinOff"];
        
        //marker.icon = [UIImage imageNamed:@"flag_icon"];
        marker.map = mapView_;
        
        idCanalPorDefecto = [modelo.canalId intValue];
    }
}

-(void)ruta:(GMSPath *)puntos tipo:(NSString*)tipo exepciones:(NSString*)exepcion{
    
    if ([exepcion isEqualToString:@"success"]) {
        
        [mapView_ clear];
        
        _ruta = puntos;
        //[_sedesArray addObject:modeloDestinodeRuta];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(modeloDestinodeRuta.latitud, modeloDestinodeRuta.longitud);
        marker.appearAnimation = kGMSMarkerAnimationPop;
        _iconViewDeatil.image = [self.constant iconodeCanalConEfecto:[modeloDestinodeRuta.canalId intValue]];
        marker.title = modeloDestinodeRuta.nombreactual;
        marker.snippet = modeloDestinodeRuta.nomenclatura;
        marker.userData = @{@"marker_id":[NSNumber numberWithInteger:[_sedesArray indexOfObject:modeloDestinodeRuta]]};
        marker.icon = [self.constant pindeCanal:[modeloDestinodeRuta.canalId intValue]];
        
        if (!modeloDestinodeRuta.oficinaAbierta)
            marker.icon = [UIImage imageNamed:@"pinOff"];
        
        marker.map = mapView_;
        
        GMSPolyline *singleLine = [GMSPolyline polylineWithPath:puntos];
        singleLine.strokeWidth = 1.5;
        if ([tipo isEqualToString:@"driving"])
            singleLine.strokeColor = self.constant.colorBlue;
        else{
            
            NSArray *styles = @[[GMSStrokeStyle solidColor:self.constant.colorBlue],
                                [GMSStrokeStyle solidColor:[UIColor clearColor]]];
            NSArray *lengths = @[@25, @20];
            singleLine.spans = GMSStyleSpans(singleLine.path, styles, lengths, kGMSLengthRhumb);
        }
        singleLine.map = mapView_;
        
    }
    else{
        
    }
}

-(BOOL)validandoTelefono:(NSString*)telefono{

    NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [test evaluateWithObject:telefono];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
