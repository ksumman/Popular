//
//  PLMediaInfo.h
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
@interface PLMediaInfo : NSObject

@property (strong, nonatomic, readonly) NSString *identifier;
@property (assign, nonatomic, readonly) PLMediaType type;
@property (assign, nonatomic, readonly) NSInteger likesCount;
@property (strong, nonatomic, readonly) NSString *link;

// image properties
@property (strong, nonatomic, readonly) NSString *lowResImageURL;
@property (strong, nonatomic, readonly) NSString *standardResImageURL;
@property (strong, nonatomic, readonly) NSString *thumbnailURL;
@property (nonatomic, readonly) CGSize lowResImageSize;
@property (nonatomic, readonly) CGSize standardResImageSize;
@property (nonatomic, readonly) CGSize thumbnailSize;

// video properties
@property (strong, nonatomic, readonly) NSString *lowResVideoURL;
@property (strong, nonatomic, readonly) NSString *standardResVideoURL;
@property (nonatomic, readonly) CGSize lowResVideoSize;
@property (nonatomic, readonly) CGSize standardResVideoSize;

//! @returns A new instance of PLPhotoInfo object initialized with information from the given dictionary.
-(instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end
