//
//  MBViewController.m
//  Moshe
//
//  Created by Moshe Berman on 4/25/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBDataSource.h"

@interface MBViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *bannerView;
@property (weak, nonatomic) IBOutlet UIPageControl *bannerPageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *informationToggle;
@property (weak, nonatomic) IBOutlet UITableView *informationTable;

@property (nonatomic, strong) MBDataSource *dataSource;

@end

@implementation MBViewController

- (id)init
{
    self = [super init];
    if (self) {
        _dataSource = [MBDataSource new];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _dataSource = [MBDataSource new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CALayer *layer = [[self bannerView] layer];

    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowRadius:4.0];
    [layer setShadowOffset:CGSizeMake(0, 2)];
    [layer setShadowOpacity:1.0];
    
    
    [[self dataSource] addObserver:self forKeyPath:@"areAppsReady" options:0 context:nil];
    [[self dataSource] addObserver:self forKeyPath:@"areReposReady" options:0 context:nil];
    [[self dataSource] reloadData];
	
	[self setTitle:@"Moshe Berman"];
}

- (void)dealloc
{
    [[self dataSource] removeObserver:self forKeyPath:@"areAppsReady"];
    [[self dataSource] removeObserver:self forKeyPath:@"areReposReady"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* KVO our data loader */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"areAppsReady"] || [keyPath isEqualToString:@"areReposReady"]) {
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - Reload

- (void)reloadData
{
    [[self informationTable] reloadData];
}

@end
