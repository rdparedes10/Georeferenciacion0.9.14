//
//  QRViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 16/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "BaseViewController.h"

@interface QRViewController : BaseViewController <AVCaptureMetadataOutputObjectsDelegate,qflowRequestProtocolDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) NSNumber *uniqueId;



@end
