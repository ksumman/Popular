//
//  PLMediaItem.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLMediaItem.h"

/*--------------------------------------------------------------------------------*/
@interface PLMediaItem()

// image properties
@property (strong, nonatomic, readonly) NSString *lowResImageURLString;
@property (strong, nonatomic, readonly) NSString *standardResImageURLString;
@property (strong, nonatomic, readonly) NSString *thumbnailURLString;
@property (nonatomic, readonly) CGSize lowResImageSize;
@property (nonatomic, readonly) CGSize standardResImageSize;
@property (nonatomic, readonly) CGSize thumbnailSize;

// video properties
@property (strong, nonatomic, readonly) NSString *lowResVideoURLString;
@property (strong, nonatomic, readonly) NSString *standardResVideoURLString;
@property (nonatomic, readonly) CGSize lowResVideoSize;
@property (nonatomic, readonly) CGSize standardResVideoSize;

// images
@property (nonatomic, strong, readwrite) UIImage *lowResImage;
@property (strong, nonatomic, readwrite) UIImage *standardResImage;
@property (strong, nonatomic, readwrite) UIImage *thumbnailImage;

@end

@implementation PLMediaItem

/*--------------------------------------------------------------------------------*/
-(instancetype) initWithDictionary: (NSDictionary *) dictionary
{
    self = [super init];
    if(self)
    {
        _identifier = [dictionary objectForKey: @"id"];
        _link = [dictionary objectForKey: @"link"];

        NSString *type = [dictionary objectForKey: @"type"];
        if([type isEqualToString: @"image"])
        {
            _type = PLMediaTypeImage;
        }
        else if([type isEqualToString: @"video"])
        {
            _type = PLMediaTypeVideo;
        }

        NSDictionary *likesDictionary = [dictionary objectForKey: @"likes"];
        _likesCount = [[likesDictionary objectForKey: @"count"] longValue];

        // low resolution image info
        NSDictionary *imageInfo = [[dictionary objectForKey: @"images"] objectForKey: @"low_resolution"];
        _lowResImageURLString = [imageInfo objectForKey: @"url"];
        NSInteger height = [[imageInfo objectForKey: @"height"] integerValue];
        NSInteger width = [[imageInfo objectForKey: @"width"] integerValue];
        _lowResImageSize = CGSizeMake(width, height);

        // standard resolution image info
        imageInfo = [[dictionary objectForKey: @"images"] objectForKey: @"standard_resolution"];
        _standardResImageURLString = [imageInfo objectForKey: @"url"];
        height = [[imageInfo objectForKey: @"height"] integerValue];
        width = [[imageInfo objectForKey: @"width"] integerValue];
        _standardResImageSize = CGSizeMake(width, height);

        // thumbnail image info
        imageInfo = [[dictionary objectForKey: @"images"] objectForKey: @"thumbnail"];
        _thumbnailURLString = [imageInfo objectForKey: @"url"];
        height = [[imageInfo objectForKey: @"height"] integerValue];
        width = [[imageInfo objectForKey: @"width"] integerValue];
        _thumbnailSize = CGSizeMake(width, height);
        
        
        // low resolution video info
        NSDictionary *videoInfo = [[dictionary objectForKey: @"videos"] objectForKey: @"low_resolution"];
        _lowResVideoURLString = [videoInfo objectForKey: @"url"];
        height = [[videoInfo objectForKey: @"height"] integerValue];
        width = [[videoInfo objectForKey: @"width"] integerValue];
        _lowResVideoSize = CGSizeMake(width, height);

        // standard resolution video info
        videoInfo = [[dictionary objectForKey: @"videos"] objectForKey: @"standard_resolution"];
        _standardResVideoURLString = [videoInfo objectForKey: @"url"];
        height = [[videoInfo objectForKey: @"height"] integerValue];
        width = [[videoInfo objectForKey: @"width"] integerValue];
        _standardResVideoSize = CGSizeMake(width, height);
    }
    return self;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Images
/*--------------------------------------------------------------------------------*/
-(UIImage *) lowResImage
{
    if (_lowResImage == nil && self.lowResImageURLString)
    {
        NSURL *url = [NSURL URLWithString:self.lowResImageURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        _lowResImage = image;
    }

    return _lowResImage;
}

/*--------------------------------------------------------------------------------*/
-(UIImage *) standardResImage
{
    if(_standardResImage == nil && self.standardResImageURLString)
    {
        NSURL *url = [NSURL URLWithString:self.standardResImageURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        _standardResImage = image;
    }
    return _standardResImage;
}

/*--------------------------------------------------------------------------------*/
-(UIImage *)  thumbnailImage
{
    if(_thumbnailImage == nil && self.thumbnailURLString)
    {
        NSURL *url = [NSURL URLWithString:self.thumbnailURLString];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        _thumbnailImage = image;
    }
    return _thumbnailImage;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Helper Methods
/*--------------------------------------------------------------------------------*/
-(NSString *) description
{
    NSString *description = [NSString stringWithFormat: @"\nType: %ld\nID: %@\nLow resolution size: %@\nStandard resolution size: %@\nThumbnail size: %@\n", self.type,  self.identifier, NSStringFromCGSize(self.lowResImageSize), NSStringFromCGSize(self.standardResImageSize), NSStringFromCGSize(self.thumbnailSize)];
    return description;
}

/*--------------------------------------------------------------------------------*/
-(BOOL) isEqual:(id)object
{
    if(object == self)
    {
        return YES;
    }
    else if([object isKindOfClass:[PLMediaItem class]])
    {
        return [[((PLMediaItem *) object) identifier] isEqualToString: self.identifier];
    }
    return NO;
}

@end
