//
//  NavigationViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 10/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "NavigationViewController.h"
#import "MapViewController.h"

@interface NavigationViewController ()
@end

@implementation NavigationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MapViewController *vc = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
 
 Tu turno ha sido generado y reservado, una vez llegues a la oficina actívalo para que puedas obtener el número con el que te atenderan.
*/

@end
