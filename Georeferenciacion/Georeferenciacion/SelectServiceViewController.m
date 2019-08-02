//
//  SelectServiceViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 25/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "SelectServiceViewController.h"
#import "QflowServicesCollectionViewCell.h"
#import "QflowTurnViewController.h"
#import "Constantes.h"

@interface SelectServiceViewController (){

    NSIndexPath *selectedService;
    MBProgressHUD *hud;
}

@end

@implementation SelectServiceViewController

@synthesize icon,name,location,distance,close,model,collectionView,titulo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"";
    
    icon.image = [self.constant iconodeCanalConEfecto:[model.canalId intValue]];
    name.text = model.nombreactual;
    location.text = model.nomenclatura;
    distance.text = model.distancia;
    close.text = model.cierraEn;
    [collectionView registerNib:[UINib nibWithNibName:@"QflowServicesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"customerId"]) {
        
        QflowRequest *requestQflow = [[QflowRequest alloc] init];
        requestQflow.delegate = self;
        [requestQflow registerActivateLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]];
    }
    
    NSDictionary *mensajeYParametros = [self.messageParameters mensaje:@"MS07"];
    if (mensajeYParametros)
        titulo.text = mensajeYParametros[@"messageContent"];
    else
        titulo.text = @"Selecciona el servicio para tu turno";
}

#pragma mark QflowRequest

-(void)registerActivateLogin:(NSDictionary*)response{
    
    [[NSUserDefaults standardUserDefaults] setObject:response[@"CustomerId"] forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width/3)-4, (self.view.frame.size.width/3)-4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2,2,2,2);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return model.serviciosQflow.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QflowServicesCollectionViewCell *cell = [collectionView_ dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
    cell.icon.image = [UIImage imageNamed:[(NSString*)model.serviciosQflow[indexPath.row][@"image"] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
    cell.name.text = model.serviciosQflow[indexPath.row][@"serviceName"];
    cell.Text.text = model.serviciosQflow[indexPath.row][@"serviceDescription"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    selectedService = indexPath;
    
    GetTurnViewController *vc = [[GetTurnViewController alloc] initWithNibName:@"GetTurnViewController" bundle:nil];
    vc.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.nameStr = model.nombreactual;
    vc.model = model.serviciosQflow[indexPath.row];
    vc.modelo = model;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)getTurn:(NSDictionary*)response{

    NSLog(@"si señores %@",response);
    
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Turno"
                                                               action:@"Generado"
                                                                label:@"Encolado"
                                                                value:nil] build]];
    
    QflowTurnViewController *vc =  [[QflowTurnViewController alloc] initWithNibName:@"QflowTurnViewController" bundle:nil];
    vc.modelo = model;
    vc.model = model.serviciosQflow[selectedService.row];
    vc.width = self.view.frame.size.width;
    vc.width = self.view.frame.size.height;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)qflowErrorRequest:(NSError*)error{

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
