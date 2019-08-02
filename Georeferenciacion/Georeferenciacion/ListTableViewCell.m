//
//  ListTableViewCell.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 24/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

@synthesize name,distance,location,close,phoneBtn,distanceHeight,locationHeight,closeHeight,phoneHeight,distceImage,locationImage,clockImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
