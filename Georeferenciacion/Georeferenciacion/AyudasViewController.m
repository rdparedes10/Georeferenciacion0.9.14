//
//  AyudasViewController.m
//  Georeferenciacion
//
//  Created by Samuel Romero on 7/07/16.
//  Copyright © 2016 Intergrupo S.A. All rights reserved.
//

#import "AyudasViewController.h"
#import "Constantes.h"

@interface AyudasViewController ()

@end

@implementation AyudasViewController

@synthesize imagenesDeAyuda,width,height,yPosition;

Constantes *constants;
float initalCloseButtonConstraintValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _pageControl.hidden = NO;
    constants = [[Constantes alloc] init];
    
    if (height == constants.iPhoneXSafeHeight)
    {
        initalCloseButtonConstraintValue = _closeButtonConstranint.constant;
        _closeButton.hidden = NO;
        _closeButtonConstranint.constant = _closeButtonConstranint.constant + constants.iPhoneXTopInset;
    }
        
    if(imagenesDeAyuda.count<2)
        _pageControl.hidden = YES;
    
    NSArray *viewsToRemove = [_scroll subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [_scroll setContentOffset:CGPointZero animated:YES];
    _scroll.contentSize = CGSizeMake(width*imagenesDeAyuda.count,height);
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    
    _pageControl.numberOfPages = imagenesDeAyuda.count;
    
    for (int i=0; i<imagenesDeAyuda.count; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((width*i)+20, yPosition+50, width-40, height-40)];
        img.image = [UIImage imageNamed:imagenesDeAyuda[i]];
        img.contentMode = UIViewContentModeScaleAspectFit;
        //img.backgroundColor = [UIColor whiteColor];
        [_scroll addSubview:img];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scroll.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.scroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)close
{
    _closeButton.hidden = YES;
    _closeButtonConstranint.constant = initalCloseButtonConstraintValue;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
