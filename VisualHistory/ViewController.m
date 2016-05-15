//
//  ViewController.m
//  VisualHistory
//
//  Created by Mattia Cantalù on 14/05/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//

#import "ViewController.h"
#import "REPhotoCollectionController.h"
#import "Photo.h"
#import "ThumbnailView.h"

@interface ViewController () <UIGestureRecognizerDelegate>
{
    CGFloat lastScale;
}
@end

@implementation ViewController

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    return [dateFormat dateFromString:string];
}

- (NSMutableArray *)prepareDatasource
{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"02/01/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"01/02/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"04/03/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"07/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"07/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"07/24/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"No_image_available.png"
                                               date:[self dateFromString:@"07/25/2012"]]];
    return datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    photoCollectionController = [[REPhotoCollectionController alloc] initWithDatasource:[self prepareDatasource]];
    photoCollectionController.title = @"Photos";
    photoCollectionController.thumbnailViewClass = [ThumbnailView class];
    
    [self addChildViewController:photoCollectionController];
    [self.view addSubview:photoCollectionController.view];
    
    
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    [photoCollectionController.view addGestureRecognizer:pgr];
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale = [gestureRecognizer scale];
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        const CGFloat kMaxScale = 1.5;
        const CGFloat kMinScale = 0.8;
        CGFloat newScale = 1 -  (lastScale - [gestureRecognizer scale]);
        photoCollectionController.groupByDate = currentScale > 1 ? NO : YES;
        
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
        [gestureRecognizer view].transform = transform;
        
        lastScale = [gestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        photoCollectionController.view.transform = photoCollectionController.defaultTransform;
        [photoCollectionController reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
