//
//  searchGoogleViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 19/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "GoogleApis.h"

@protocol locationFindDelegate;

@interface searchGoogleViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UISearchControllerDelegate,UITableViewDelegate,UITableViewDataSource,googleApisRequest>{

    id<locationFindDelegate> __unsafe_unretained delegate;
}

@property (nonatomic,assign) id<locationFindDelegate> __unsafe_unretained delegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@protocol locationFindDelegate

@optional

-(void)findLocation:(CLLocationCoordinate2D)coordinate;

@end
