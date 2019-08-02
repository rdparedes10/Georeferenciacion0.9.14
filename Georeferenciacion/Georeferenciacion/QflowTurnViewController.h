//
//  QflowTurnViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 27/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "alertaView.h"
#import "Modelo.h"

@interface QflowTurnViewController : BaseViewController <qflowRequestProtocolDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *minute;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *globalScrollView;
@property (strong, nonatomic) NSMutableDictionary *model;
@property (strong, nonatomic) Modelo *modelo;
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) bool showTurn;
@property (weak, nonatomic) IBOutlet UIButton *activaTurnoBtn;
@property (weak, nonatomic) IBOutlet alertaView *_alertView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet UIButton *_openCloseScroll;
@property (weak, nonatomic) IBOutlet UILabel *tiempoEstimadoTitulo;
@property (weak, nonatomic) IBOutlet UILabel *tituloControlScroll;



- (IBAction)activate;
- (IBAction)cancel;
- (IBAction)pageControlTouch:(UIPageControl *)sender;
- (IBAction)openCloseScroll:(UIButton *)sender;

@end
