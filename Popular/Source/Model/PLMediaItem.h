//
//  PLMediaItem.h
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*--------------------------------------------------------------------------------*/
typedef NS_ENUM(NSInteger, PLMediaType) {
    PLMediaTypeImage = 1,
    PLMediaTypeVideo
};

/*--------------------------------------------------------------------------------*/
@interface PLMediaItem : NSObject

@property (strong, nonatomic, readonly) NSString *identifier;
@property (assign, nonatomic, readonly) PLMediaType type;
@property (assign, nonatomic, readonly) NSInteger likesCount;
@property (strong, nonatomic, readonly) NSString *link;

@property (strong, nonatomic, readonly) UIImage *lowResImage;
@property (strong, nonatomic, readonly) UIImage *standardResImage;
@property (strong, nonatomic, readonly) UIImage *thumbnailImage;

//! YES if the current user has liked this media, NO otherwise.
@property (assign, nonatomic, readonly) BOOL likeStatus;

//! @returns A new instance of PLPhotoInfo object initialized with information from the given dictionary.
-(instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
