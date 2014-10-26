//
//  PLMediaInfo.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLMediaInfo.h"

@implementation PLMediaInfo

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
        _lowResImageURL = [imageInfo objectForKey: @"url"];
        NSInteger height = [[imageInfo objectForKey: @"height"] integerValue];
        NSInteger width = [[imageInfo objectForKey: @"width"] integerValue];
        _lowResImageSize = CGSizeMake(width, height);

        // standard resolution image info
        imageInfo = [[dictionary objectForKey: @"images"] objectForKey: @"standard_resolution"];
        _standardResImageURL = [imageInfo objectForKey: @"url"];
        height = [[imageInfo objectForKey: @"height"] integerValue];
        width = [[imageInfo objectForKey: @"width"] integerValue];
        _standardResImageSize = CGSizeMake(width, height);

        // thumbnail image info
        imageInfo = [[dictionary objectForKey: @"images"] objectForKey: @"thumbnail"];
        _thumbnailURL = [imageInfo objectForKey: @"url"];
        height = [[imageInfo objectForKey: @"height"] integerValue];
        width = [[imageInfo objectForKey: @"width"] integerValue];
        _thumbnailSize = CGSizeMake(width, height);
        
        
        // low resolution video info
        NSDictionary *videoInfo = [[dictionary objectForKey: @"videos"] objectForKey: @"low_resolution"];
        _lowResVideoURL = [videoInfo objectForKey: @"url"];
        height = [[videoInfo objectForKey: @"height"] integerValue];
        width = [[videoInfo objectForKey: @"width"] integerValue];
        _lowResVideoSize = CGSizeMake(width, height);

        // standard resolution video info
        videoInfo = [[dictionary objectForKey: @"videos"] objectForKey: @"standard_resolution"];
        _standardResVideoURL = [videoInfo objectForKey: @"url"];
        height = [[videoInfo objectForKey: @"height"] integerValue];
        width = [[videoInfo objectForKey: @"width"] integerValue];
        _standardResVideoSize = CGSizeMake(width, height);
    }
    return self;
}

/*--------------------------------------------------------------------------------*/
-(NSString *) description
{
    NSString *description = [NSString stringWithFormat: @"\nType: %ld\nID: %@\nLow resolution size: %@\nStandard resolution size: %@\nThumbnail size: %@\n", self.type,  self.identifier, NSStringFromCGSize(self.lowResImageSize), NSStringFromCGSize(self.standardResImageSize), NSStringFromCGSize(self.thumbnailSize)];
    return description;
}

@end
