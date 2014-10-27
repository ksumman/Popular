//
//  PLDataModel.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLDataModel.h"

static NSString * const APIHost = @"https://api.instagram.com";
static NSString * const InstagramAPIClientID = @"a5bccca60af74a0487d54a88005286a0";
static const NSInteger MediaItemCount = 50;

static PLDataModel *defaultDataModel = nil;
static dispatch_once_t dispatchOnceToken;
static NSString * access_token;

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
        defaultDataModel = [[self alloc] init];
    });
    return defaultDataModel;
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
    defaultDataModel = nil;
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
    access_token = accessToken;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Fetching Images
/*--------------------------------------------------------------------------------*/
-(void) fetchPopularImages: (FetchImagesRequestCompletionBlock) completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *igPopularImagesURL = [NSURL URLWithString: [self igPopularMediaURLString]];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL: igPopularImagesURL];
        [urlRequest setHTTPMethod:@"GET"];

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
            //NSLog(@"pagination: %@", [jsonResponseData objectForKey: @"pagination"]);
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
-(NSString *) igPopularMediaURLString
{
    NSString *popularMediaURLString;
    if(access_token)
    {
        popularMediaURLString = [NSString stringWithFormat: @"%@/v1/media/popular?client_id=%@&access_token=%@&count=%ld", APIHost, InstagramAPIClientID, access_token, MediaItemCount];
    }
    else
    {
        popularMediaURLString = [NSString stringWithFormat: @"%@/v1/media/popular?client_id=%@&count=%ld", APIHost, InstagramAPIClientID, MediaItemCount];
    }
    return popularMediaURLString;
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Like/Unlike Media
/*--------------------------------------------------------------------------------*/
//! Sends request to toggle the user_has_liked value for the given media item.
-(void) toggleUserLike: (PLMediaItem *) mediaItem
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL userHasAlreadyLiked = [mediaItem userHasLiked];
        if(userHasAlreadyLiked)
        {
            [self unlikeMediaItem: mediaItem];
        }
        else
        {
            [self likeMediaItem: mediaItem];
        }
    });
}

/*--------------------------------------------------------------------------------*/
-(void) likeMediaItem: (PLMediaItem *) mediaItem
{
    NSString *likeMediaURLString = [NSString stringWithFormat: @"%@/v1/media/%@/likes", APIHost, mediaItem.identifier];
    NSURL *likeMediaURL = [NSURL URLWithString: likeMediaURLString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL: likeMediaURL];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"utf-8" forHTTPHeaderField:@"charset"];
    NSString *accessTokenString = [NSString stringWithFormat:@"access_token=%@", access_token];
    NSData *httpBody = [accessTokenString dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody: httpBody];

    NSError *urlRequestError;
    NSHTTPURLResponse *urlResponse;
    [NSURLConnection sendSynchronousRequest:urlRequest
                          returningResponse:&urlResponse
                                      error:&urlRequestError];
    if(urlResponse.statusCode == 200)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mediaItem setUserHasLiked: YES];
        });
    }
    else
    {
        //TODO: handle error
        NSLog(@"Error occurred: %ld: %@", (long)urlResponse.statusCode, urlRequestError);
    }
}

/*--------------------------------------------------------------------------------*/
-(void) unlikeMediaItem: (PLMediaItem *) mediaItem
{
    NSString *unlikeMediaURLString = [NSString stringWithFormat: @"%@/v1/media/%@/likes?access_token=%@", APIHost, mediaItem.identifier, access_token];
    NSURL *unlikeMediaURL = [NSURL URLWithString: unlikeMediaURLString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL: unlikeMediaURL];
    [urlRequest setHTTPMethod:@"DELETE"];

    NSError *urlRequestError;
    NSHTTPURLResponse *urlResponse;
    [NSURLConnection sendSynchronousRequest:urlRequest
                          returningResponse:&urlResponse
                                      error:&urlRequestError];
    if(urlResponse.statusCode == 200)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [mediaItem setUserHasLiked: NO];
        });
    }
    else
    {
        //TODO: handle error
        NSLog(@"Error occurred: %ld: %@", (long)urlResponse.statusCode, urlRequestError);
    }
}

@end
