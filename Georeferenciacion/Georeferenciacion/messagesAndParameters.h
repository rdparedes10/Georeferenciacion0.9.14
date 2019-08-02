//
//  messagesAndParameters.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 22/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messagesAndParameters : NSObject

-(NSDictionary*)mensaje:(NSString*)idMessage;

-(NSString*)parametro:(int)idMParameter;

@end
