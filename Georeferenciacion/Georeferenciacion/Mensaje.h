//
//  Mensaje.h
//  SSL pinning iOS
//
//  Created by Samuel Romero on 27/09/16.
//  Copyright © 2016 Infinum Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol messageDelegate;

@interface Mensaje : NSObject <UIAlertViewDelegate>{
    
    id <messageDelegate> __unsafe_unretained delegate;
}

@property (nonatomic, assign) id <messageDelegate> delegate;

- (void)showMessage:(NSString*)title message:(NSString*)message cancelButton:(NSString*)cancelLabel actionButton:(NSString*)actionLabel;

@end

@protocol messageDelegate
@optional
-(void)messageButtonSelected:(NSInteger)buttonSelected;
@end
