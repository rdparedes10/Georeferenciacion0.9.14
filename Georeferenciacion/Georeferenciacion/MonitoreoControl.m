//
//  MonitoreoControl.m
//  Georeferenciacion
//
//  Created by Ricardo Grajales on 1/24/17.
//  Copyright © 2017 Intergrupo S.A. All rights reserved.
//

#import "MonitoreoControl.h"

@implementation MonitoreoControl

//Request & Return On/Off Value
-(void)MonitoreoControlWithURLString:(NSString*)URLString WithTimeOut:(int)timeOut completionBlock:(void(^)(BOOL state, float Distance))block
{    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *DataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
         
            if (!error) {
                                
                NSError *error2;
                NSDictionary *ResponseDictionary=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error2];
                
                BOOL ResponseBool=NO;
                NSString *ResponseString;
                
                float ResponseDistance;
                float ResponseTime;
                NSString *ResponseDistanceString;
                NSString *ResponseTimeString;
                
                if (!error2) {
                    ResponseString=[ResponseDictionary objectForKey:@"statusLocation"];
                    ResponseBool=[ResponseString boolValue];
                    
                    ResponseDistanceString=[ResponseDictionary objectForKey:@"distanceLocation"];
                    ResponseDistance=[ResponseDistanceString floatValue]*1000.0;
                    
                    [[NSUserDefaults standardUserDefaults] setFloat:ResponseDistance forKey:@"distanceLocation"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    ResponseTimeString=[ResponseDictionary objectForKey:@"timeLocation"];
                    ResponseTime=[ResponseTimeString floatValue]/60;
                    
                    [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"timeLocation"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                    
                    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"lastTimeSent"] == 0.0) {
                       
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
                        
                        [[NSUserDefaults standardUserDefaults] setFloat:[components hour] forKey:@"lastTimeSent"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                else {
                    ResponseString=@"";
                    ResponseBool=NO;
                    
                    ResponseDistanceString=@"";
                    ResponseDistance=[[NSUserDefaults standardUserDefaults] floatForKey:@"distanceLocation"];
                }

                block(ResponseBool,ResponseDistance);
            }
            else{
                block(NO,[[NSUserDefaults standardUserDefaults] floatForKey:@"distanceLocation"]);
            }
         });
    }];
    
    [DataTask resume];
}

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
