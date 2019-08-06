//
//  ListViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 26/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Modelo.h"

@protocol returnObjectCellDelegate;

@interface ListViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UISearchControllerDelegate>{

    id <returnObjectCellDelegate> __unsafe_unretained delegate;
}

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSDate *dateCharge;
@property (nonatomic, assign) id <returnObjectCellDelegate> delegate;
@property (nonatomic,weak) IBOutlet UITableView *tabla;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) NSString *name;
@property (nonatomic) Boolean *hideTitle;
@property (nonatomic,strong) NSMutableArray *canales;
@property (nonatomic,strong) NSMutableArray *setCanalesArray;
@property (nonatomic) BOOL turnFilter;

@end

@protocol returnObjectCellDelegate

@optional

-(void)returObjectSelectedCell:(Modelo *)model;

@end
