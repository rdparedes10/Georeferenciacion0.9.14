//
//  MapViewController.h
//  Georeferenciacion
//
//  Created by Armando Restrepo on 4/20/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ListViewController.h"
#import "FiltroView.h"
#import "Modelo.h"
#import "ScheduleViewController.h"
#import "FilterViewController.h"
#import "searchGoogleViewController.h"

@interface MapViewController : BaseViewController<qflowRequestProtocolDelegate,repositorioDelegate,GMSMapViewDelegate,filterSearchDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,locationFindDelegate,returnObjectCellDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIView *infoView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *filtrosView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nombreLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *direccionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *distanciaLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *serviciosText;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *horarioLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *telefonoLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *botonRuta;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *botonQflow;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelQflow;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *botonHorario;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *botonUpDown;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *botonLeftRight;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *turnList;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconViewDeatil;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *turn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *channelLabel;

@property (unsafe_unretained, nonatomic) IBOutlet GMSMapView *mapView_;
@property(nonatomic,strong) ScheduleViewController *scheduleViewController;
@property(nonatomic,retain)UIPopoverPresentationController *dateTimePopover8;
@property (nonatomic, weak) IBOutlet FiltroView *filterView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) NSMutableArray *channelsArray;
@property (nonatomic, strong) NSMutableArray *sedesArray;
@property (nonatomic, strong) GMSPath *ruta;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconPhoneViewDeatil;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconScheduleViewDeatil;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *turnListH;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *horarioViewDetailHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *telefonoViewDetailHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *tituloHorariosEspecialesHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *horariosEspecialesHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *heightInfoView;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *trailingFilterView;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *heightFilterView;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *scheduleLading;

extern NSMutableDictionary *filterParameters;

- (IBAction)openHelp;
- (IBAction)turnListAction;
- (IBAction)openQflowSelectService;
- (IBAction)openFilter;
- (IBAction)openFilters;
- (IBAction)ruta:(id)sender;
- (IBAction)openChannels;
- (IBAction)filtrarPorEstado;
- (IBAction)openList;
- (IBAction)openDetail;
- (IBAction)openDetailHour;
- (IBAction)openTurn;
- (IBAction)openLayar;
- (IBAction)llamar;
@end
