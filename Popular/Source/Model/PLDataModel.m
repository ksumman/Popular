//
//  PLDataModel.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLDataModel.h"

static NSString * const InstagramAPIClientID = @"a5bccca60af74a0487d54a88005286a0";

static PLDataModel *_defaultDataModel = nil;
static dispatch_once_t dispatchOnceToken;

/*--------------------------------------------------------------------------------*/
@interface PLDataModel()
@end

@implementation PLDataModel

/*--------------------------------------------------------------------------------*/
#pragma mark - Life Cycle
/*--------------------------------------------------------------------------------*/
+ (instancetype) defaultDataModel
{
    dispatch_once(&dispatchOnceToken, ^{
        _defaultDataModel = [[self alloc] init];
    });
    return _defaultDataModel;
}

/*--------------------------------------------------------------------------------*/
- (instancetype) init
{
    self = [super init];
    return self;
}

/*--------------------------------------------------------------------------------*/
-(void) dealloc
{
    _defaultDataModel = nil;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Login
/*--------------------------------------------------------------------------------*/
//! @returns URL string to load the log-in page.
+(NSString *) loginURLString
{
    NSString *redirectURI = @"https://localhost";
    NSString *scopes = @"basic+likes";
    NSString *loginUrlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&scope=%@&response_type=token", InstagramAPIClientID , redirectURI, scopes];
    return loginUrlString;
}

-(void) userAuthenticationSuccessful: (NSString *) accessToken
{
    
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Fetching Images
/*--------------------------------------------------------------------------------*/
-(void) fetchPopularImages: (FetchImagesRequestCompletionBlock) completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *igPopularImagesURL = [NSURL URLWithString: [self igPopularImagesURLString]];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setURL: igPopularImagesURL];

        NSError *urlRequestError;
        NSHTTPURLResponse *urlResponse;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest
                                                     returningResponse:&urlResponse
                                                                 error:&urlRequestError];
        if(urlResponse.statusCode == 200)
        {
            NSError *error;
            id jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                  options:kNilOptions
                                                                    error:&error];
            NSLog(@"Meta: %@", [jsonResponseData objectForKey: @"meta"]);
            NSLog(@"pagination: %@", [jsonResponseData objectForKey: @"pagination"]);
            NSArray *photosData = [jsonResponseData objectForKey: @"data"];

            NSMutableArray *photos = [[NSMutableArray alloc] init];
            // parse result data
            for(NSDictionary *photoInfoDictionary in photosData)
            {
                PLMediaItem *photo = [[PLMediaItem alloc] initWithDictionary: photoInfoDictionary];
                if(photo)
                {
                    [photos addObject: photo];
                }
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(completionBlock)
                {
                    completionBlock(photos, nil);
                }
            });
        }
        else
        {
            //TODO: handle errors
            NSLog(@"Error occurred: %ld: %@", (long)urlResponse.statusCode, urlRequestError);
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(completionBlock)
                {
                    completionBlock(nil, urlRequestError);
                }
            });
        }
    });
}

/*--------------------------------------------------------------------------------*/
//! @returns URL string for popular images on Instagram.
-(NSString *) igPopularImagesURLString
{
    NSString *endpointURLString = [NSString stringWithFormat: @"https://api.instagram.com/v1/media/popular?client_id=%@", InstagramAPIClientID];
    return endpointURLString;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Like/Unlike Media
/*--------------------------------------------------------------------------------*/


@end
