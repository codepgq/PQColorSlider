//
//  PQColorSlider.h
//
//
//  Created by pgq on 2017/5/19.
//  Copyright © 2017年 pgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PQColorSlider : UISlider


/**
 colors
 颜色数组
 [red, blue]
 
 ⚠️必须和 locations 对应
 */
@property (nonatomic, strong) NSArray<UIColor*>* colors;

/**
 locations
 每个颜色对应的位置信息
 [0.0, 1.0]
 
 ⚠️必须和 colors 对应
 */
@property (nonatomic, strong) NSArray<NSNumber*>* locations;

/**
 borderColor
 边框颜色
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 borderWidth
 边框宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 colorHeight
 颜色的高度
 */
@property (nonatomic, assign) CGFloat colorHeight;

/**
 on move slider
 移动的时候
 */
@property (nonatomic, strong) void(^valueChangeBlock)(CGFloat progress);


/**
 reload UI
 重新设置UI
 */
- (void)reloadUI;
@end
