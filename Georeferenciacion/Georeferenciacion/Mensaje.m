//
//  Mensaje.m
//  SSL pinning iOS
//
//  Created by Samuel Romero on 27/09/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import "Mensaje.h"

@implementation Mensaje

@synthesize delegate;

- (void)showMessage:(NSString*)title message:(NSString*)message cancelButton:(NSString*)cancel actionButton:(NSString*)action{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:action,nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [delegate messageButtonSelected:buttonIndex];
}

@end
