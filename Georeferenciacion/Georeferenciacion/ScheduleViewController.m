//
//  ScheduleViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 29/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "ScheduleViewController.h"
#import "MyCustomCell.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

@synthesize modelo,nombreLbl,tipoDeHorario,tableView,horarios;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    tapGesture.numberOfTapsRequired=1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGesture];
    
    nombreLbl.text = modelo.nombreactual;
    tipoDeHorario.text = @"Horario Regular/Extendido";
    horarios = modelo.horarios;
    
    //tableView.rowHeight = UITableViewAutomaticDimension;
    //tableView.estimatedRowHeight = 23;
    
    
}

-(void)imageTapped{

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)Dissmis:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [horarios count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 44.0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MyCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.leftLabel.text = [NSString stringWithFormat:@"⋅ %@:",[horarios objectAtIndex:indexPath.row][@"day"]];
    cell.rightLabel.text = [horarios objectAtIndex:indexPath.row][@"schedules"];
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
