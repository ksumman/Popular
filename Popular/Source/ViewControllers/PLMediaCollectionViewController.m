//
//  PLMediaCollectionViewController.m
//  Popular
//
//  Created by Kumar Summan on 10/26/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "PLMediaCollectionViewController.h"
#import "PLDataModel.h"
#import "PLMediaCell.h"
#import "PLImageViewController.h"
#import "UIColor+Popular.h"


static NSString * const ShowImageSegueIdentifier = @"ShowImageSegueIdentifier";

/*--------------------------------------------------------------------------------*/
@interface PLMediaCollectionViewController ()<UICollectionViewDelegate,
                                              UICollectionViewDataSource,
                                              UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *mediaItems;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@end

/*--------------------------------------------------------------------------------*/
@implementation PLMediaCollectionViewController

static NSString * const reuseIdentifier = @"PLMediaCell";

/*--------------------------------------------------------------------------------*/
#pragma mark - ViewController Life Cycle
/*--------------------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.mediaItems = [[NSMutableArray alloc] init];
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 4;

    // Register cell classes
    [self.collectionView registerClass:[PLMediaCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    [self requestPopularMedia];
}

/*--------------------------------------------------------------------------------*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*--------------------------------------------------------------------------------*/
#pragma mark - Managing Media
/*--------------------------------------------------------------------------------*/
//! Sends a request to the data model to fetch popular media.
-(void) requestPopularMedia
{
    __weak PLMediaCollectionViewController *weakSelf = self;
    [[PLDataModel defaultDataModel] fetchPopularImages:^(NSArray *mediaItems, NSError *error) {
        if(mediaItems)
        {
            [weakSelf addItemsToMediaCollection: mediaItems];
        }
        else
        {
            [weakSelf failedToFetchMedia: error];
        }
    }];
}

/*--------------------------------------------------------------------------------*/
-(void) addItemsToMediaCollection: (NSArray *) mediaItems
{
    [self.mediaItems addObjectsFromArray: mediaItems];
    [self.collectionView reloadData];
}

/*--------------------------------------------------------------------------------*/
-(void) failedToFetchMedia: (NSError *) error
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Request Failed"
                                                                             message:@"Model couldn't fetch images."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction: [UIAlertAction actionWithTitle:@"Dismiss"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil]];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

/*--------------------------------------------------------------------------------*/
#pragma mark <UICollectionViewDataSource>
/*--------------------------------------------------------------------------------*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/*--------------------------------------------------------------------------------*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.mediaItems count];
}

/*--------------------------------------------------------------------------------*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLMediaCell *mediaCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                     forIndexPath:indexPath];
    PLMediaItem *mediaInfo = [self.mediaItems objectAtIndex: indexPath.item];

    __weak PLMediaCollectionViewController *weakSelf = self;
    __weak PLMediaCell *weakMediaCell = mediaCell;
    // add operation to update thumbnail image on cell
    NSBlockOperation *thumbnailImageOperation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage *thumbnailImage = [mediaInfo lowResImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                // on completion, check if the cell is visible, if yes, show the thumbnail
                if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath])
                {
                    weakMediaCell.imageView.image = thumbnailImage;
                }
            });
    }];
    [self.thumbnailQueue addOperation:thumbnailImageOperation];

    return mediaCell;
}

/*--------------------------------------------------------------------------------*/
#pragma mark <UICollectionViewDelegate>
/*--------------------------------------------------------------------------------*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:ShowImageSegueIdentifier
                              sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if([[segue identifier] isEqualToString: ShowImageSegueIdentifier])
    {
        PLImageViewController *destinationImageViewController = segue.destinationViewController;
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *selectedItemIndexPath = [indexPaths firstObject];
        PLMediaItem *selectedItem = [self.mediaItems objectAtIndex: selectedItemIndexPath.item];
        destinationImageViewController.mediaItem = selectedItem;
    }
}

/*--------------------------------------------------------------------------------*/
#pragma mark <UICollectionViewDelegateFlowLayout>
/*--------------------------------------------------------------------------------*/

-(CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width);
}


@end
