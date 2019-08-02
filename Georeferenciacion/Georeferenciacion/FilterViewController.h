//
//  FilterViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 12/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repositorio.h"
#import "BaseViewController.h"

@protocol filterSearchDelegate;

@interface FilterViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,repositorioDelegate, UIAlertViewDelegate>{

    id <filterSearchDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, assign) id <filterSearchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *channelLabel;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;
@property (strong, nonatomic) NSMutableArray *filterarray;
@property (weak, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSNumber *channelId;

- (IBAction)search;
- (IBAction)clean;

@end

@protocol filterSearchDelegate

@optional

-(void)respuestaDelFiltro:(NSMutableArray*)canales;

@end
