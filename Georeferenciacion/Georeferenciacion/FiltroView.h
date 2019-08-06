//
//  FiltroView.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 25/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repositorio.h"

@interface FiltroView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tabla;

@end
