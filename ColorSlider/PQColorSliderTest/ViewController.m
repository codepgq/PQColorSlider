//
//  ViewController.m
//  SliderDemo
//
//  Created by 盘国权 on 2018/8/20.
//  Copyright © 2018年 pgq. All rights reserved.
//

#import "ViewController.h"
#import "PQColorSlider.h"

#define RandomColor [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PQColorSlider *colorSlider;
@property (weak, nonatomic) IBOutlet UILabel *borderWidthLabel;
@property (weak, nonatomic) IBOutlet UIStepper *borderStepper;
@property (weak, nonatomic) IBOutlet UIView *borderColorView;
@property (weak, nonatomic) IBOutlet UILabel *colorsLabel;
@property (weak, nonatomic) IBOutlet UIStepper *colorsStepper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _borderWidthLabel.text = @"borderWidth: 1";
    _colorSlider.borderWidth = 1;
    _borderStepper.value = 1;
    
    _colorSlider.borderColor = [UIColor blackColor];
    _borderColorView.backgroundColor = [UIColor blackColor];
    
    _colorsStepper.value = 3;
    _colorSlider.colors = @[RandomColor, RandomColor, RandomColor];
    _colorSlider.locations = @[@0.0, @0.5, @1.0];
    
    [_colorSlider reloadUI];
}
- (IBAction)borderWidthStepper:(UIStepper *)sender {
    _colorSlider.borderWidth = sender.value;
    _borderWidthLabel.text = [NSString stringWithFormat:@"borderWidth: %.1f", sender.value];
    [_colorSlider reloadUI];
}
- (IBAction)randomBorderColor:(UIButton *)sender {
    _colorSlider.borderColor = RandomColor;
    _borderColorView.backgroundColor = _colorSlider.borderColor;
    [_colorSlider reloadUI];
}
- (IBAction)randomSliderColor:(UIButton *)sender {
    
    NSMutableArray *colors = [@[] mutableCopy];
    
    int i = 0;
    while (i<_colorsStepper.value) {
        [colors addObject:RandomColor];
        i++;
    }
    _colorSlider.colors = colors;
    [_colorSlider reloadUI];
}
- (IBAction)colorsStepper:(UIStepper *)sender {
    
    _colorsLabel.text = [NSString stringWithFormat:@"colors: %.0f", sender.value];
    if (sender.value < 2) {
        _colorSlider.locations = @[@0.0, @1.0];
    } else {
        NSMutableArray <NSNumber*>* locations = [@[@0.0] mutableCopy];
        
        CGFloat count = (sender.value - 2);
        CGFloat step = 1 / (((int)sender.value % 2 == 0) ? sender.value : sender.value - 1);
        CGFloat loc = step;
        while (count > 0) {
            [locations addObject:@(loc)];
            loc += step;
            count--;
        }
        
        [locations addObject:@1.0];
        
        _colorSlider.locations = locations;
        [self randomSliderColor:nil];
    }
}

@end
