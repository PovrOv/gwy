//
//  MapViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/10/4.
//  Copyright © 2015年 lixiaohu. All rights reserved.
//

#import "MapViewController.h"
#include "Kannotation.h"
@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置信息";
    CLLocationCoordinate2D coords = self.coordinate;
    
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center.latitude=coords.latitude;
    theRegion.center.longitude =coords.longitude;
    theRegion.span.longitudeDelta= 0.005f;
    theRegion.span.latitudeDelta= 0.005f;
    
    Kannotation *annotation = [[Kannotation alloc] init];
    annotation.coordinate = self.coordinate;
    [_mapView addAnnotation:annotation];
    [_mapView setRegion:theRegion animated:YES];
    

//    _mapView addAnnotation:<#(nonnull id<MKAnnotation>)#>
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    _coordinate = coordinate;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
