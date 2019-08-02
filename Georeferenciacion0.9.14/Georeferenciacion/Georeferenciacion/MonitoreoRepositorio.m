
//
//  MonitoreoRepositorio.m
//  Georeferenciacion
//
//  Created by Sebastian Gomez on 31/10/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "MonitoreoRepositorio.h"

@implementation MonitoreoRepositorio

@synthesize delegate;

-(void)request:(NSString*)url{
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSURLSession *urlSession2 = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    [[urlSession2 dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse* _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error && response != nil) {
                [delegate requestResponse:response errorState:NO];
            } else {
                [delegate requestResponse:response errorState:YES];
            }
        });
    }] resume];
    
}

-(void)request:(NSString*)urlString dictionaryJSON:(NSDictionary*)dictionary methodString:(NSString*)method timeOut:(int)timeOut{
    
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:timeOut];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:method];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                
                switch (((NSHTTPURLResponse *)response).statusCode) {
                    case 200:{
                    
                        NSError * _Nullable __autoreleasing * _Nullable error2;
                        NSDictionary *json;
                        
                        @try {
                            
                            json = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:error2];
                        }
                        @catch (NSException *exception) {
                            NSLog(@"%@", exception.reason);
                            [delegate requestResponse:response.description errorState:YES];
                        }
                        @finally {
                            
                            NSLog(@"%@",json);
                            [delegate requestResponse:json[@"msg"] errorState:NO];
                        }
                    }
                        break;
                        
                    default:{
                    
                        [delegate requestResponse:response.description errorState:YES];
                    }
                        break;
                }
                
            } else {
                [delegate requestResponse:error.description errorState:YES];
            }
        });
    }];
    
    [postDataTask resume];
}

#pragma mark - NSURLSession delegate
/*
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){

        if([challenge.protectionSpace.host isEqualToString:@"geolocalizacioncert.bancolombia.com"]){
            
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}
*/

@end
