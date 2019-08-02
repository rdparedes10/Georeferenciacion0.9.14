//
//  alertaView.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 21/06/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "alertaView.h"

@implementation alertaView

@synthesize _icon,_texto;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. Load the .xib file .xib file must match classname
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        self.view.frame = self.bounds;
        // 2. Set the bounds if not set by programmer (i.e. init called)
        if(CGRectIsEmpty(frame)) {
            self.bounds = self.view.bounds;
        }
        
        // 3. Add as a subview
        [self addSubview:self.view];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        // 1. Load .xib file
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        self.view.frame = self.bounds;
        // 2. Add as a subview
        [self addSubview:self.view];
        
    }
    return self;
}


@end
