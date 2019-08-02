//
//  BaseViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 9/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize message,messageParameters,constant,request,qflowRequest,hud,tracker,vc,with;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    messageParameters = [[messagesAndParameters alloc] init];
    constant = [[Constantes alloc] init];
    request = [[Repositorio alloc] init];
    qflowRequest = [[QflowRequest alloc] init];
    
    tracker = [[GAI sharedInstance] defaultTracker];
    
    vc = [[AyudasViewController alloc] initWithNibName:@"AyudasViewController" bundle:nil];
    vc.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
//    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile"]];
//    self.navigationItem.titleView = imageview;
    
    with = self.view.frame.size.width;
    
}

-(void)message:(NSString*)messageTitle messageDescription:(NSString*)messageDescription cancelBtn:(NSString*)cancel otherBtn:(NSString*)other{

    message = [[UIAlertView alloc] initWithTitle:messageTitle
                                         message:messageDescription
                                        delegate:self
                               cancelButtonTitle:cancel
                               otherButtonTitles:other, nil];
    
    [message show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
