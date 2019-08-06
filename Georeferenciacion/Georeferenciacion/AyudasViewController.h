//
//  AyudasViewController.h
//  Georeferenciacion
//
//  Created by Samuel Romero on 7/07/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AyudasViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeButtonConstranint;
@property(nonatomic) float width;
@property(nonatomic) float height;
@property(nonatomic) float yPosition;
@property(strong, nonatomic) NSArray *imagenesDeAyuda;

- (IBAction)close;

@end
