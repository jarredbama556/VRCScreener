//
//  ViewController.m
//  VRCScreener
//
//  Created by Jarred Alldredge on 1/21/15.
//  Copyright (c) 2015 Vision Research. All rights reserved.
//

#import "ViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "APPData.h"
#import "FileViewerViewController.h"

@interface ViewController () <DBRestClientDelegate>
{
    NSMutableArray *paths;
}
@property (nonatomic, strong) DBRestClient *restClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    [self.restClient loadMetadata:@"/"];
}

- (IBAction)didPressLink {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    [self.collectionView reloadData];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    paths =[[NSMutableArray alloc] init];
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *savePath = [NSString stringWithFormat:@"%@%@%@", [path objectAtIndex:0], @"/", file.filename];
            [self.restClient loadFile:file.path intoPath:savePath];
            [paths addObject:savePath];
            [APPData setValue:paths forKey:@"paths"];
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}


# pragma mark collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                              forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    NSURL *url = [NSURL URLWithString:[paths objectAtIndex:indexPath.row]];
    NSData *imgdata=[[NSData alloc]initWithContentsOfURL:url];
    UIImage *image=[[UIImage alloc]initWithData:imgdata];
    [imageView setImage:image];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [APPData setValue:[paths objectAtIndex:indexPath.row] forKey:@"path"];
    
    FileViewerViewController *viewController = [[FileViewerViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
}



@end
