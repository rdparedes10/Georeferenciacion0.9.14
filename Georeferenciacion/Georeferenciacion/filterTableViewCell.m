//
//  filterTableViewCell.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 12/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "filterTableViewCell.h"

@implementation filterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [super setSelectionStyle:UITableViewCellSelectionStyleNone];

    // Configure the view for the selected state
}

@end
