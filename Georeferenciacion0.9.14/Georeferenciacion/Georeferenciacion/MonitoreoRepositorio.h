//
//  MonitoreoRepositorio.h
//  Georeferenciacion
//
//  Created by Sebastian Gomez on 31/10/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol monitoreoRepositorioDelegate;

@interface MonitoreoRepositorio : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate>{
    
    id <monitoreoRepositorioDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, assign) id <monitoreoRepositorioDelegate> delegate;

-(void)request:(NSString*)url;
-(void)request:(NSString*)urlString dictionaryJSON:(NSDictionary*)dictionary methodString:(NSString*)method timeOut:(int)timeOut;

@end

@protocol monitoreoRepositorioDelegate
@optional
-(void)requestResponse:(NSString*)response errorState:(BOOL)error;
@end
