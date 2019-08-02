//
//  FiltroView.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 25/04/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "FiltroView.h"

@implementation FiltroView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
        [self insertSubview:self.view atIndex:0];
        self.view.frame = self.bounds;
        return self;
    }
    return nil;
}


@end
