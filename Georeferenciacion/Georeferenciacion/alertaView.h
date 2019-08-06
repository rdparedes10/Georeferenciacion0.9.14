//
//  alertaView.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 21/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface alertaView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *_icon;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *_texto;


@end
