//
//  SelectServiceViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 25/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "BaseViewController.h"
#import "Modelo.h"
#import "GetTurnViewController.h"

@interface SelectServiceViewController : BaseViewController <UICollectionViewDelegate,UICollectionViewDataSource,getTurnDelegate,qflowRequestProtocolDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *close;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) Modelo *model;

@end
