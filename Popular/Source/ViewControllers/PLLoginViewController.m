//
//  PLLoginViewController.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLLoginViewController.h"
#import "PLDataModel.h"

/*--------------------------------------------------------------------------------*/
@interface PLLoginViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

/*--------------------------------------------------------------------------------*/
@implementation PLLoginViewController

/*--------------------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.webView.delegate = self;
    NSString *loginURLString = [PLDataModel loginURLString];
    NSURLRequest *urlRequest= [NSURLRequest requestWithURL:[NSURL URLWithString:loginURLString]];
    [self.webView loadRequest:urlRequest];
}

/*--------------------------------------------------------------------------------*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*--------------------------------------------------------------------------------*/
#pragma mark - UIWebViewDelegate Callbacks
/*--------------------------------------------------------------------------------*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSRange accessTokenKeyRange = [urlString rangeOfString: @"#access_token="];
    if(accessTokenKeyRange.location != NSNotFound)
    {
        NSInteger urlStringLength = urlString.length;
        NSInteger tokenValueLength = urlStringLength - (accessTokenKeyRange.location + accessTokenKeyRange.length);
        NSRange accessTokenValueRange = NSMakeRange(accessTokenKeyRange.location+ accessTokenKeyRange.length, tokenValueLength);
        NSString *accessToken = [urlString substringWithRange: accessTokenValueRange];

        [[PLDataModel defaultDataModel] userAuthenticationSuccessful: accessToken];
        [self.delegate loginComplete];
    }
    return YES;
}

@end
