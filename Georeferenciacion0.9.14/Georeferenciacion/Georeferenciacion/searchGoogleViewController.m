//
//  searchGoogleViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 19/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "searchGoogleViewController.h"
#import "searchTableViewCell.h"
#import "autoCompleteModel.h"

@interface searchGoogleViewController (){

    GMSPlacesClient *placesClient;
    GoogleApis *request;
    NSTimer *searchDelayer;
    NSMutableArray *placesHistory;
}

@end

@implementation searchGoogleViewController

@synthesize searchBar,resultArray,tableView,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [searchBar becomeFirstResponder];
    
    placesHistory = [[NSMutableArray alloc] init];
    
    request = [[GoogleApis alloc] init];
    request.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"placesHistory"])
        placesHistory = [[NSUserDefaults standardUserDefaults] objectForKey:@"placesHistory"];
    
    [tableView registerNib:[UINib nibWithNibName:@"searchTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UIImageView * im = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 12)];
    im.image = [UIImage imageNamed:@"powered"];
    [footer addSubview:im];
    
    self.searchDisplayController.searchResultsTableView.tableFooterView = footer;
}

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section{

    if (tableView_ == self.searchDisplayController.searchResultsTableView)
        return [resultArray count];
    else
        return [placesHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPat{

    searchTableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        
        cell = [[searchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    autoCompleteModel *model = [[autoCompleteModel alloc] init];
    
    if (tableView_ == self.searchDisplayController.searchResultsTableView){
        model = [resultArray objectAtIndex:indexPat.row];
        cell.textLabel.text = model.predictionString;
        cell.detailTextLabel.text = model.predictionDescription;
    }
    else{
    
        cell.textLabel.text = placesHistory[placesHistory.count-indexPat.row-1][@"primaryText"];
        cell.detailTextLabel.text = placesHistory[placesHistory.count-indexPat.row-1][@"secoundText"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (tableView_ == self.searchDisplayController.searchResultsTableView){
        
        NSMutableArray *ar = [[NSMutableArray alloc] initWithArray:placesHistory];
        
        autoCompleteModel *model = [[autoCompleteModel alloc] init];
        model = [resultArray objectAtIndex:indexPath.row];
        
        NSDictionary *dic = @{@"primaryText":model.predictionString,@"secoundText":model.predictionDescription,@"locationId":model.predictionId};
        
        if (ar.count<5)
            [ar addObject:dic];
        else{
            [ar addObject:dic];
            [ar removeObjectAtIndex:0];
        }

        [[NSUserDefaults standardUserDefaults] setObject:ar forKey:@"placesHistory"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [request getLatLngWithLocationId:model.predictionId];
        
    }else{
        
        [request getLatLngWithLocationId:placesHistory[placesHistory.count-indexPath.row-1][@"locationId"]];
    }
    
    //[self.navigationController popViewControllerAnimated:YES];
    
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchDelayer invalidate], searchDelayer=nil;
    searchDelayer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                         target:self
                                                       selector:@selector(doDelayedSearch:)
                                                       userInfo:searchText
                                                        repeats:NO];
}

-(void)getLatLng:(CLLocationCoordinate2D)coordinate{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [delegate findLocation:coordinate];
}

-(void)doDelayedSearch:(NSTimer *)t
{
    searchDelayer = nil; // important because the timer is about to release and dealloc itself
    
    resultArray = [[NSMutableArray alloc] init];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(12, -86) coordinate:CLLocationCoordinate2DMake(-4.6,-82)];
    filter.type = kGMSPlacesAutocompleteTypeFilterCity;
    
    placesClient = [[GMSPlacesClient alloc] init];
    [placesClient autocompleteQuery:searchBar.text
                             bounds:bounds
                             filter:nil
                           callback:^(NSArray *results, NSError *error) {
                               if (error != nil) {
                                   NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                   return;
                               }
                               
                               for (GMSAutocompletePrediction* result in results) {
                                   NSLog(@"Result '%@' with placeID %@ %f %f", result.attributedPrimaryText.string, result.placeID, result.accessibilityActivationPoint.x, result.accessibilityActivationPoint.y);
                                   
                                   autoCompleteModel *model = [[autoCompleteModel alloc] init];
                                   model.predictionString = result.attributedPrimaryText.string;
                                   model.predictionDescription = result.attributedSecondaryText.string;
                                   model.predictionId = result.placeID;
                                   [resultArray addObject:model];
                                   [self.searchDisplayController.searchResultsTableView reloadData];
                                   
                               }
                           }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
