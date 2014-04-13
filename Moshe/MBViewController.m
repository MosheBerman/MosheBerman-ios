//
//  MBViewController.m
//  Moshe
//
//  Created by Moshe Berman on 4/25/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

/* Frameworks. */
@import QuartzCore;

/* Some of our own headers. */
#import "MBViewController.h"
#import "MBDataSource.h"
#import "MBDisplayCategories.h"
#import "MBBannerCell.h"
#import "MOSImageManager.h"

/* Model objects */
#import "MOSApp.h"
#import "MOSBlogPost.h"
#import "MOSRepo.h"
#import "MOSBanner.h"

/* Cell re-use identifiers. */
static NSString *CellReuseIdentifier = @"Cell ID";
static NSString *BannerCellReuseIdentifer = @"Banner Cell";

/**
 *
 */

@interface MBViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** 
 *  A banner for the top of tbe screen
 */
@property (weak, nonatomic) IBOutlet UICollectionView *bannerView;

/**
 *  A toggle for the table
 */

@property (weak, nonatomic) IBOutlet UISegmentedControl *informationToggle;

/**
 *  The main data table
 */

@property (weak, nonatomic) IBOutlet UITableView *informationTable;

/**
 *  A data source object that handles loading the data from the various feeds.
 */

@property (nonatomic, strong) MBDataSource *dataSource;

/**
 *  A timer for the top banner
 */

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _dataSource = [[MBDataSource alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Wire up our table. */
    [[self informationTable] setDelegate:self];
    [[self informationTable] setDataSource:self];
    
    /* Wire up our banner collection view. */
    [[self bannerView] setDataSource:self];
    [[self bannerView] setDelegate:self];
    
    /* Where everybody knows your name. */
	[self setTitle:@"Moshe Berman"];
    
    /* We need to make sure we have table cells & banner cells. */
    [[self informationTable] registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    [[self bannerView] registerClass:[MBBannerCell class] forCellWithReuseIdentifier:BannerCellReuseIdentifer];
    
    UINib *nib = [UINib nibWithNibName:@"MBBannerCell" bundle:[NSBundle mainBundle]];
    [[self bannerView] registerNib:nib forCellWithReuseIdentifier:BannerCellReuseIdentifer];
    
    /* Respond to category changes by reloading the table. */
    [[self informationToggle] addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
    /**
     *  Reload the data source table.
     *
     *  TODO: Cache the downloaded data and attempt to reload from disk first.
     */
    
    [[self dataSource] reloadDataWithCompletion:^{
        [self reloadData];
    }];
    
    [[self dataSource] loadBannersWithCompletion:^{
        [[self bannerView] reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
        if ([self timer]) {
            [[self timer] invalidate];
        }
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(cycleBanners) userInfo:nil repeats:YES];
        [self setTimer:timer];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** ----
 *  @name Reloading the UI
 *  ----
 */

/**
 *  This method reloads the table.
 */

- (void)reloadData
{
    [[self informationTable] reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/** -----
 *  @name UITableViewDataSource
 *  ----
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    
    rowCount = [self expectedCount];
    
    /* Leave a few rows for a "no data" message. */
    if (rowCount == 0) {
        rowCount = 3;
    }
    
    return rowCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    [[cell textLabel] setText:@""]; //  Empty the text in case of recycled cells.
    
    /* This case is true when there is no data for a given category. */
    if (0 == [self expectedCount])
    {
        /* Display a "no data" message in the middle row. */
        if (1 == [indexPath row])
        {
            [[cell textLabel] setText:NSLocalizedString(@"Nothing to Display", @"The message we use for when there's no data.")];
            [[cell textLabel] setTextColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        }
        
        //  Clear interaction related properties
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    /* ...otherwise, we'll show the data for the category. */
    else
    {
        /* Set up the default cell properties. */
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [[cell textLabel] setTextColor:[UIColor blackColor]];
        [[cell textLabel] setTextAlignment:NSTextAlignmentLeft];
        [[cell imageView] setImage:nil];
        
        NSInteger selectedIndex = [[self informationToggle] selectedSegmentIndex];
        
        /* If we are displaying apps, we want enough rows for the apps. */
        if (selectedIndex == MBDisplayCategoryApp)
        {
            MOSApp *app = [[self dataSource] apps][indexPath.row];
            [[cell textLabel] setText:[app name]];
        }
        
        /* If we are displaying blog posts, we want enough rows for the blog posts. */
        else if (selectedIndex == MBDisplayCategoryBlog)
        {
            MOSBlogPost *post = [[self dataSource] blogPosts][indexPath.row];
            [[cell textLabel] setText:[post title]];
        }
        
        /* If we are displaying code, we want enough rows for the GitHub repos. */
        else if (selectedIndex == MBDisplayCategoryCode)
        {
            MOSRepo *repo = [[self dataSource] repos][indexPath.row];
            [[cell textLabel] setText:[repo name]];
        }
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /* If there's no data, do nothing... */
    if (0 == [self expectedCount])
    {
        return;
    }
    
    /*
     *  ...otherwise, we're interacting with an object, so open it.
     *
     *  For now, just open the associated URL. 
     *
     *  TODO: Open fancier detail views.
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger selectedIndex = [[self informationToggle] selectedSegmentIndex];
    
    if (selectedIndex == MBDisplayCategoryApp)
    {
        MOSApp *app = [[self dataSource] apps][indexPath.row];
        NSURL *url = [app appURL];
        [self openURL:url];
        
    }
    
    else if (selectedIndex == MBDisplayCategoryBlog)
    {
        MOSBlogPost *post = [[self dataSource] blogPosts][indexPath.row];
        NSURL *url = [post URL];
        [self openURL:url];
    }

    else if (selectedIndex == MBDisplayCategoryCode)
    {
        MOSRepo *repo = [[self dataSource] repos][indexPath.row];
        NSURL *url = [repo htmlURL];
        [self openURL:url];
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger count = [[[self dataSource] banners] count];
    
    if (0 == count) {
        count = 1;
    }
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BannerCellReuseIdentifer forIndexPath:indexPath];

    if (self.dataSource.banners.count > indexPath.row)
    {
        
        MOSBanner *banner = [[self dataSource] banners][indexPath.row];
        NSURL *imageURL = [banner imageURL];
    
        [[MOSImageManager sharedManager] loadImageForKey:[imageURL absoluteString] withHandler:^(UIImage *image) {
            cell.imageView.image = image;
        }];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self bannerView] bounds].size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
     if (self.dataSource.banners.count > indexPath.row)
     {
         MOSBanner *banner = [[self dataSource] banners][indexPath.row];
         
         NSURL *url = [banner url];
         [self openURL:url];
     }
    
}
#pragma mark - Helpers

/**
 *  A quick-and-dirty method that tries to open any URL.
 */

- (void)openURL:(NSURL *)url
{
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

/**
 *  Returns the number of rows we would need for a given
 *  category to display in a table without accounting
 *  for the case of no data. We can use this to decide in
 *  our table delegate if we have to show a regulare cell
 *  or a "no data" cell.
 *
 *  @return The number of rows we'd need for the active category.
 */

- (NSInteger)expectedCount
{
    
    NSInteger selectedIndex = [[self informationToggle] selectedSegmentIndex];
    
    NSInteger rowCount = 0;
    
    /* If we are displaying apps, we want enough rows for the apps. */
    if (selectedIndex == MBDisplayCategoryApp)
    {
        rowCount = [[[self dataSource] apps] count];
    }
    
    /* If we are displaying blog posts, we want enough rows for the blog posts. */
    else if (selectedIndex == MBDisplayCategoryBlog)
    {
        rowCount = [[[self dataSource] blogPosts] count];
    }
    
    /* If we are displaying code, we want enough rows for the GitHub repos. */
    else if (selectedIndex == MBDisplayCategoryCode)
    {
        rowCount = [[[self dataSource] repos] count];
    }
    
    return rowCount;
}

#pragma mark - Banner Cycle

- (void)cycleBanners
{
    
    NSIndexPath *path = [[self bannerView] indexPathsForVisibleItems][0];
    
    NSInteger index = [path row];
    
    index++;
    
    index = index % 3;
    
    NSIndexPath *newIndex = [NSIndexPath indexPathForItem:index inSection:0];
    
    [[self bannerView] scrollToItemAtIndexPath:newIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


@end
