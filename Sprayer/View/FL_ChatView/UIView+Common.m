//
//  UIView+Common.m
//  56finance
//
//  Created by FangLin on 1/13/16.
//
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (void)setLayerWidth:(CGFloat)width layerColor:(UIColor *)layerColor radius:(CGFloat)radius {
    self.clipsToBounds = YES;
    self.layer.borderWidth = MAX(width, 0);
    self.layer.borderColor = (layerColor ?: [UIColor whiteColor]).CGColor;
    self.layer.cornerRadius = MAX(radius, 0);
}

@end
