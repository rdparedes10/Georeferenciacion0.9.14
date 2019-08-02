//
//  ScheduleViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 29/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Modelo.h"

@interface ScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nombreLbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *tipoDeHorario;
@property(nonatomic,retain) Modelo *modelo;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *horarios;

-(IBAction)Dissmis:(id)sender;

@end
