 //
//  FileViewerViewController.m
//  VRCScreener
//
//  Created by Jarred Alldredge on 1/28/15.
//  Copyright (c) 2015 Vision Research. All rights reserved.
//

#import "FileViewerViewController.h"
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import "APPData.h"
@interface FileViewerViewController ()
{
    NSDictionary *exifDic;
    NSDictionary *tiffDic;
}
@end

@implementation FileViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self exifGet];
}

-(void) exifGet {
    
    NSURL * imageURL = [NSURL URLWithString:[APPData valueForKey:@"path"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    
    UIImage * image = [UIImage imageWithData:imageData];
    _imageView.image = image;
    
    CGImageSourceRef mySourceRef = CGImageSourceCreateWithURL((CFURLRef)imageURL, NULL);
    NSDictionary *myMetadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL));
    exifDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary];
    tiffDic = [myMetadata objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    
    NSArray *allVals = [tiffDic allValues];
    //NSArray *myArray = [[allVals objectAtIndex:0] componentsSeparatedByString:@","];
    
    self.txtFld.text = [allVals objectAtIndex:0];
}

@end
