//
//  autoCompleteModel.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 20/05/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface autoCompleteModel : NSObject
@property (nonatomic, strong) NSString *predictionString;
@property (nonatomic, strong) NSString *predictionDescription;
@property (nonatomic, strong) NSString *predictionId;
@end
