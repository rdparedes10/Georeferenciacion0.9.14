//
//  QRViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 16/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "QRViewController.h"
#import "SelectServiceViewController.h"
#import "TurnViewController.h"

@interface QRViewController (){

    MBProgressHUD *hud;
}

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
//@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading:(NSString *)lecturaQr;
//-(void)loadBeepSound;

@end

@implementation QRViewController

@synthesize uniqueId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"";
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    
    self.qflowRequest.delegate = self;
    
    
}

-(void)viewDidAppear:(BOOL)animated{

    [self validateAccessToCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Qflow Request

-(void)turnoActivado:(NSDictionary*)response{
    
    [hud hide:YES];
    
    if ([response[@"objReturnValue"][@"ReturnCode"] intValue] == 0) {
        
        [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Turno"
                                                                   action:@"Generado"
                                                                    label:@"Descongelado"
                                                                    value:nil] build]];
        
        NSMutableDictionary *Dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"]];
        Dic[@"activate"]=@1;
        [[NSUserDefaults standardUserDefaults] setObject:Dic forKey:@"turn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        TurnViewController *vc = [[TurnViewController alloc] initWithNibName:@"TurnViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)qflowErrorRequest:(NSError*)error{
    
    [hud hide:YES];
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS03"];
    if (mensajeYParametros)
        [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
    else
        [self message:@"Información" messageDescription:@"En este momento el sistema no está disponible. Por favor intente más tarde." cancelBtn:@"Aceptar" otherBtn:nil];
}

#pragma mark - Private method implementation

- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}

- (void)validateAccessToCamera{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        [self startReading];
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        NSLog(@"%@", @"Camera access not determined. Ask for permission.");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if(granted)
             {
                 NSLog(@"Granted access to %@", AVMediaTypeVideo);
                 [self startReading];
             }
             else
             {
                 NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                 [self camDenied];
             }
         }];
    }
    else
    {
        [self camDenied];
    }
}

- (void)camDenied
{
    NSLog(@"%@", @"Denied camera access");
    
    NSString *alertText;
    NSString *alertButton;
    
    
    alertText = @"Tus opciones de privacidad previenen el acceso a la cámara para poder leer el QRCode. Sin este permiso no es posible acceder a esta funcionalidad.";
    
    alertButton = @"Cancelar";
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:alertText
                          delegate:self
                          cancelButtonTitle:alertButton
                          otherButtonTitles:@"Ir a Configuración", nil];
    alert.tag = 121;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%d",buttonIndex);
    
    if (alertView.tag == 121 && buttonIndex == 1)
    {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)stopReading:(NSString *)lecturaQr{
    // Stop video capture and make the capture session object nil
    
    if ([[NSString stringWithFormat:@"%@",uniqueId] isEqualToString:lecturaQr]) {
        
        _isReading = NO;
        [_captureSession stopRunning];
        _captureSession = nil;
        
        // Remove the video preview layer from the viewPreview view's layer.
        [_videoPreviewLayer removeFromSuperlayer];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.qflowRequest activarTurno:[[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"unitId"] intValue] processId:[[[NSUserDefaults standardUserDefaults] objectForKey:@"turn"][@"ProcessId"] intValue]];
        
        
    }
    else{
    
        _isReading = NO;
        [_captureSession stopRunning];
        _captureSession = nil;
        
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS22"];
        if (mensajeYParametros)
            [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
        else
            [self message:@"Oficina no coincide" messageDescription:@"El turno que solicitaste no pertenece a esta oficina." cancelBtn:@"Aceptar" otherBtn:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            [self performSelectorOnMainThread:@selector(stopReading:) withObject:[metadataObj stringValue]  waitUntilDone:NO];
        }
    }
    
    
}

@end
