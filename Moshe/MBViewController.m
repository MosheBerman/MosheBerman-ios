//
//  MBViewController.m
//  Moshe
//
//  Created by Moshe Berman on 4/25/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBViewController.h"

@interface MBViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *bannerView;
@property (weak, nonatomic) IBOutlet UIPageControl *bannerPageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *informationToggle;
@property (weak, nonatomic) IBOutlet UITableView *informationTable;

@end

@implementation MBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
