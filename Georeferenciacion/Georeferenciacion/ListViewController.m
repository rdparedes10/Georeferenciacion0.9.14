//
//  ListViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 26/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "ListViewController.h"
#import "SelectServiceViewController.h"
#import "alertaView.h"
#import "MapViewController.h"
#import "ListTableViewCell.h"
#import "Modelo.h"
#import "Constantes.h"

@interface ListViewController ()
{
    NSString *verDetalles;
}

@end

@implementation ListViewController

@synthesize delegate,dateCharge;

int idCanal;
Constantes *constantsListView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    constantsListView = [[Constantes alloc] init];
    
    if(self.hideTitle){
        self.lblTitle.hidden = YES;
    }
    //    self.lblTitle.text = self.name;
    
    [_tabla registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.title = @"";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if ([self.canales count]>0) {
        
        Modelo *modelo = [[Modelo alloc] init];
        modelo = [self.canales objectAtIndex:0];
        idCanal = [modelo.canalId intValue];
    
    }else if (self.setCanalesArray.count >0){
        
        Modelo *modelo = [[Modelo alloc] init];
        modelo = [self.setCanalesArray objectAtIndex:0];
        idCanal = [modelo.canalId intValue];
    }
    
    if (_turnFilter) {
        
        _canales = [[NSMutableArray alloc] init];
        
        for (int i = 0; i<_setCanalesArray.count; i++) {
            
            Modelo *md = [[Modelo alloc] init];
            md = _setCanalesArray[i];
            NSLog(@"%@ %d",md.nombreactual,md.qflow);
            
            if (md.qflow) {
                [_canales addObject:md];
            }
        }
        
        [self.tabla reloadData];
    }
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS06"];
    if (mensajeYParametros)
        verDetalles = mensajeYParametros[@"messageContent"];
    else
        verDetalles = @"Ver detalles de esta oficina";
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"couchMarks"][@"mark2"] boolValue] && _turnFilter) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"couchMarks"]];
        
        dic[@"mark2"] = @1;
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"couchMarks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.vc.width = self.view.frame.size.width;
        self.vc.height = self.view.frame.size.height;
        self.vc.imagenesDeAyuda = @[@"Coachmark3.jpg"];
        [self presentViewController:self.vc animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.canales count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_turnFilter)
        return 130;
    else
        return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    viewHeader.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
    
    UIImageView *icono = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
    icono.image = [self.constant iconodeCanalConEfecto:idCanal];
    icono.contentMode = UIViewContentModeScaleToFill;
    [viewHeader addSubview:icono];
    
    if (_turnFilter) {
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, tableView.frame.size.width-75, 50)];
        name.lineBreakMode = NSLineBreakByWordWrapping;
        name.numberOfLines = 3;
        name.textColor = [UIColor grayColor];
        name.font = [UIFont fontWithName:@"Arimo" size:13];
        name.adjustsFontSizeToFitWidth = YES;
        
        NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS04"];
        if (mensajeYParametros)
            name.text = mensajeYParametros[@"messageContent"];
        else
            name.text = @"En estas oficinas cerca de ti puedes solicitar un turno sin necesidad de irte a hacer fila en una sucursal.";
        
        [viewHeader addSubview:name];
        
        alertaView *_alertaView = [[alertaView alloc] init];
        mensajeYParametros = [self.messageParameters mensaje:@"MS05"];
        if (mensajeYParametros)
            _alertaView._texto.text = mensajeYParametros[@"messageContent"];
        else
            _alertaView._texto.text = @"Ten en cuenta que puedes solicitar un turno hasta 30 minutos antes del cierre de la oficina";
        _alertaView.frame = CGRectMake(8, 56, self.view.frame.size.width-16, 67);
        [viewHeader addSubview:_alertaView];
        
    }else{
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, tableView.frame.size.width-75, 20)];
        name.textColor = self.constant.colorBlue;
        name.font = [UIFont fontWithName:@"Arimo" size:18];
        name.text =_name;
        [viewHeader addSubview:name];
    }
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];;
    
    float heightCell = 0;
    
    Modelo *modelo = [[Modelo alloc] init];
    
    modelo = [self.canales objectAtIndex:indexPath.row];
    
    cell.name.text = modelo.nombreactual;
    cell.location.text = modelo.nomenclatura;
    cell.distance.text = modelo.distancia;
    cell.close.text = modelo.cierraEn;
    
    if ([modelo.cierraEn isEqualToString:@""]){
        cell.closeHeight.constant=0;
    }
    
    if ([modelo.telefono isEqualToString:@""]){
        cell.phoneHeight.constant = 0;
    }
    else{
        
        heightCell += 55;
    }
    
    heightCell += [self getLabelHeight:cell.name]+[self getLabelHeight:cell.location]+[self getLabelHeight:cell.distance]+[self getLabelHeight:cell.close];
    
    return heightCell;
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    //Estos condicional es un ajuste para poder ajustar el alto de la celda en todas las resoluciones y dandole soporte a iOS 7
    int Aux = 0;
    
    if (self.view.frame.size.width > 320) {
        Aux += 30;
    }
    
    if (self.view.frame.size.width > 375) {
        Aux += 60;
    }
    
    CGSize constraint = CGSizeMake(label.frame.size.width+Aux, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height+14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListTableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:@"Cell"];
    
    Modelo *modelo = [[Modelo alloc] init];
    modelo = [self.canales objectAtIndex:indexPath.row];
    
    if (!cell) {
        
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if ([modelo.cierraEn isEqualToString:@""])
        cell.closeHeight.constant=0;
    
    if (!_turnFilter){
        
        [cell.phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        [cell.phoneBtn setTitle:modelo.telefono forState:UIControlStateNormal];
    }else{
        
        [cell.phoneBtn setImage:[UIImage imageNamed:@"turnWhite"] forState:UIControlStateNormal];
        [cell.phoneBtn setTitle:verDetalles forState:UIControlStateNormal];
        
        if (modelo.oficinaAbierta && modelo.oficinaActiva && [self validateOpenOffice:modelo]) {
            [cell.phoneBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:68/255.0 blue:141/255.0 alpha:1]];
        } else {
            [cell.phoneBtn setBackgroundColor:[UIColor colorWithRed:74/255.0 green:117/255.0 blue:141/255.0 alpha:1]];
        }
        
    }
    cell.phoneBtn.tag = indexPath.row;
    
    cell.name.text = modelo.nombreactual;
    cell.location.text = modelo.nomenclatura;
    cell.distance.text = modelo.distancia;
    cell.close.text = modelo.cierraEn;
    
    if ([modelo.telefono isEqualToString:@""])
        cell.phoneHeight.constant = 0;
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    [cell.phoneBtn addTarget:self action:@selector(phone:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_turnFilter) {
        
        Modelo *model = [[Modelo alloc] init];
        model = [self.canales objectAtIndex:indexPath.row];
        
        if (model.oficinaAbierta && model.oficinaActiva) {
            
            if ( [self validateOpenOffice:model] ){
                
                SelectServiceViewController *vc = [[SelectServiceViewController alloc] initWithNibName:@"SelectServiceViewController" bundle:nil];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else{
        
        [delegate returObjectSelectedCell:[self.canales objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(BOOL)validateOpenOffice:(Modelo*)model{
    
    
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:dateCharge];
    
    NSString *parametro = [self.messageParameters parametro:7];
    int dato;
    if (parametro)
        dato = [[self.messageParameters parametro:7] intValue];
    else
        dato = 1800;
    
    if(model.secondsToClose-secondsBetween <= dato)
    {
        return NO;
    }
    return YES;
}

-(void)phone:(id)sender{
    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* myButton = (UIButton*)sender;
        
        Modelo *model = [[Modelo alloc] init];
        model = [self.canales objectAtIndex:myButton.tag];
        
        if (_turnFilter) {
            
            if (model.oficinaAbierta && model.oficinaActiva) {
                
                if ( [self validateOpenOffice:model] ){
                    
                    SelectServiceViewController *vc = [[SelectServiceViewController alloc] initWithNibName:@"SelectServiceViewController" bundle:nil];
                    vc.model = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
        }else{
            if ([self validandoTelefono:model.telefono]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",model.telefono]]];
            }
            
        }
    }
}

-(BOOL)validandoTelefono:(NSString*)telefono{
    
    NSString *phoneRegex = @"[235689][0-9]{6}([0-9]{3})?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [test evaluateWithObject:telefono];
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
