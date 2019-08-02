//
//  FilterViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 12/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "FilterViewController.h"
#import "MapViewController.h"
#import "filterTableViewCell.h"

@interface FilterViewController (){

    NSMutableArray *parametros;
}

@end

@implementation FilterViewController

//NSMutableDictionary *filterParameters;

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.request.delegate = self;
    parametros = [[NSMutableArray alloc] initWithArray:filterParameters[@"filterProperties"]];
    _channelLabel.text = _name;
}

-(void)Reachability:(int)status{

}

-(void)sedes:(NSMutableArray *)sedes{

    if ([sedes count]==0){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS30"];
        if (mensajeYParametros)
            [self message:mensajeYParametros[@"messageTitle"] messageDescription:mensajeYParametros[@"messageContent"] cancelBtn:@"Aceptar" otherBtn:nil];
        else
            [self message:@"No se encontraron canales" messageDescription:@"No se encontraron canales con este filtro." cancelBtn:@"Aceptar" otherBtn:nil];
    }else{
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [delegate respuestaDelFiltro:sedes];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 23.0;
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.filterarray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.filterarray objectAtIndex:section][@"filters"] count];//[_filterarray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 33;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, vi.bounds.size.width-40, 25)];
    lb.font = [UIFont fontWithName:@"Arimo" size:15.0];
    lb.text = [self.filterarray objectAtIndex:section][@"filterCategoryName"];
    lb.textColor = self.constant.colorBlue;
    [vi addSubview:lb];
    vi.backgroundColor = [UIColor whiteColor];
    _iconImageView.image = [self.constant iconodeCanalConEfecto:[_channelId intValue]];
    return vi;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    filterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"filterTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(filterTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.iconImageView.image = [self selected:[self.filterarray objectAtIndex:indexPath.section][@"filters"][indexPath.row][@"filterProperty"]];
    cell.nameLabel.text = [self.filterarray objectAtIndex:indexPath.section][@"filters"][indexPath.row][@"filterName"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    filterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString * Aux = [self.filterarray objectAtIndex:indexPath.section][@"filters"][indexPath.row][@"filterProperty"];
    
    if ([parametros count] == 0) {
        [parametros addObject:Aux];
    }
    else{
    
        int detected = -1;
        
        for (int i = 0; i<[parametros count] && detected<0; i++) {
            
            if ([Aux isEqualToString:parametros[i]]) {
                detected = i;
            }
        }
        
        if (detected<0) {
            [parametros addObject:Aux];
        }
        else{
            
            [parametros removeObjectAtIndex:detected];
        }
    }
    
    cell.iconImageView.image = [self selected:Aux];
    cell.nameLabel.text = [self.filterarray objectAtIndex:indexPath.section][@"filters"][indexPath.row][@"filterName"];
}

-(UIImage*)selected:(NSString*)filterCategory{

    int detected = -1;
    
    for (int i = 0; i<[parametros count] && detected<0; i++) {
        
        if ([filterCategory isEqualToString:parametros[i]]) {
            detected = i;
        }
    }
    
    if (detected<0)
        return [UIImage imageNamed:@"ciclreGray"];
    else
        return [UIImage imageNamed:@"circleCheck"];
    

}

- (IBAction)search {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    filterParameters[@"filterProperties"] = parametros;
    [self.request filtrarCanales:filterParameters];
}

- (IBAction)clean{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    filterParameters[@"filterProperties"] = @[];
    [self.request filtrarCanales:filterParameters];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}



@end
