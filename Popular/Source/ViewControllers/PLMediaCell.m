//
//  PLMediaCell.m
//  Popular
//
//  Created by Kumar Summan on 10/26/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLMediaCell.h"

@implementation PLMediaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.clipsToBounds = YES;
        [self addSubview: _imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints: @[
                                [NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0.0],
                                [NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0
                                                              constant:0.0],
                                [NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0.0],
                                [NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:0.0]
         ]];
    }
    
    return self;
    
}

-(void) prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
