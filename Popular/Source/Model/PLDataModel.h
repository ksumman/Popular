//
//  PLDataModel.h
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLMediaItem.h"

typedef void (^LoginRequestCompletionBlock)(NSError *error);
typedef void (^FetchImagesRequestCompletionBlock)(NSArray *images, NSError *error);

@interface PLDataModel : NSObject

+(instancetype) defaultDataModel;

//! @returns URL string to load the log-in page.
+(NSString *) loginURLString;

-(void) userAuthenticationSuccessful: (NSString *) accessToken;

-(void) fetchPopularImages: (FetchImagesRequestCompletionBlock) completionBlock;

//! Call this method to like/unlike the media item.
-(void) toggleLikeStatus: (PLMediaItem *) mediaItem;

@end
