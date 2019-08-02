//
//  ListTableViewCell.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 24/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *close;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIImageView *distceImage;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (weak, nonatomic) IBOutlet UIImageView *clockImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;


@end
