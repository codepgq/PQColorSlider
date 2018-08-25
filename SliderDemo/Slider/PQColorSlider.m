//
//  PQColorSlider.m
//  
//
//  Created by pgq on 2017/5/19.
//  Copyright © 2017年 pgq. All rights reserved.
//

#import "PQColorSlider.h"

#pragma mark - extensions
@implementation UIColor(ColorSlider)
+ (UIImage *)colorToImageWithColors:(NSArray<UIColor *>*)colors locations:(NSArray<NSNumber*>*)locations size:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    
    NSAssert(colors || locations, @"colors and locations must has value");
    
    NSAssert(colors.count == locations.count, @"Please make sure colors and locations count is equal");
    
    //create CGContextRef
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    if (borderWidth > 0 && borderColor) {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(size.width * 0.01, 0, size.width * 0.98, size.height) cornerRadius:size.height * 0.5];
        
        [borderColor setFill];
        
        [path fill];
    }
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(size.width * 0.01 + borderWidth, borderWidth, size.width * 0.98 - borderWidth * 2, size.height - borderWidth * 2) cornerRadius:size.height * 0.5];
    
    //绘制渐变
    [self drawLinearGradient:gc path:path.CGPath colors:colors locations:locations];
    
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


+ (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                colors:(NSArray<UIColor*>*)colors
                  locations:(NSArray<NSNumber*>*)locations
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSMutableArray *colorefs = [@[] mutableCopy];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [colorefs addObject:(__bridge id) obj.CGColor];
    }];
    
    
    CGFloat l[locations.count];
    for (int i = 0; i < locations.count; i++) {
        l[i] = locations[i].floatValue;
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colorefs, l);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end


@interface PQColorSlider()
@property (nonatomic, strong) UIImageView * imgView;
@end

@implementation PQColorSlider

#pragma mark - publid property
- (void)valueChange{
    if (self.valueChangeBlock) {
        self.valueChangeBlock(self.value);
    }
}


#pragma mark - public method
- (void)reloadUI {
    [self drawNewImage];
}

#pragma mark - system method
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (CGRectEqualToRect(self.imgView.frame, CGRectZero)) {
        CGRect imgViewFrame = self.imgView.frame;
        imgViewFrame.size.width = self.frame.size.width;
        imgViewFrame.size.height = _colorHeight;
        imgViewFrame.origin.y = (self.frame.size.height - _colorHeight) * 0.5;
        self.imgView.frame = imgViewFrame;
        [self drawNewImage];
    }
    
}

#pragma mark - private method
- (void)drawNewImage{
    UIImage *image = [UIColor colorToImageWithColors:_colors locations:_locations size:CGSizeMake(self.frame.size.width, _colorHeight) borderWidth:_borderWidth borderColor:_borderColor];
    self.imgView.image = image;
}


- (void)setup{
    
    self.colorHeight = 20;
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self insertSubview:imgView atIndex:4];
    self.imgView = imgView;
    
    self.tintColor = [UIColor clearColor];
    self.minimumTrackTintColor = [UIColor clearColor];
    self.maximumTrackTintColor = [UIColor clearColor];
    
    [self addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventValueChanged];
}



@end
