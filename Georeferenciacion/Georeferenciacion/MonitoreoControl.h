//
//  MonitoreoControl.h
//  Georeferenciacion
//
//  Created by Ricardo Grajales on 1/24/17.
//  Copyright © 2017 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonitoreoControl : NSObject <NSURLSessionDelegate>

-(void)MonitoreoControlWithURLString:(NSString*)URLString WithTimeOut:(int)timeOut completionBlock:(void(^)(BOOL state, float Distance))block;

@end
