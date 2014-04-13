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

/* Cell re-use identifiers. */
static NSString *CellReuseIdentifier = @"Cell ID";

/**
 *
 */

@interface MBViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *bannerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *informationToggle;
@property (weak, nonatomic) IBOutlet UITableView *informationTable;

@property (nonatomic, strong) MBDataSource *dataSource;

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
    
    /** Hook up some KVO goodness here. */
    [[self dataSource] addObserver:self forKeyPath:@"areAppsReady" options:0 context:nil];
    [[self dataSource] addObserver:self forKeyPath:@"areBlogPostsReady" options:0 context:nil];
    [[self dataSource] addObserver:self forKeyPath:@"areReposReady" options:0 context:nil];
    
    /**
     *  Reload the data source table.
     *
     *  TODO: Cache the downloaded data and attempt to reload from disk first.
     */
    
    [[self dataSource] reloadData];
	
    /* Where everybody knows your name. */
	[self setTitle:@"Moshe Berman"];
    
    /* We need to make sure we have table cells. */
    [[self informationTable] registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    
    /* Respond to category changes by reloading the table. */
    [[self informationToggle] addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc
{
    /**
     *  LLDB calls [super dealloc] for us with ARC, but we need to remove our KVO by ourselves.
     *  Please KVO responsibly.
     */
    
    [[self dataSource] removeObserver:self forKeyPath:@"areAppsReady"];
    [[self dataSource] removeObserver:self forKeyPath:@"areBlogPostsReady"];
    [[self dataSource] removeObserver:self forKeyPath:@"areReposReady"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** ----
 *  @name KVO
 *  ----
 */

/**
 *  This method handles KVO for our our data loader.
 *  See the official documentation for more on this method.
 *
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"areAppsReady"] || [keyPath isEqualToString:@"areReposReady"] || [keyPath isEqualToString:@"areBlogPostsReady"]) {
        
        /**
         *  Call on the main thread explicitly, because the network operations that change these values
         *  may live on some other thread.
         */
        
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
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
    [[self informationTable] reloadData];
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
        
        /* Clear the other cells. */
        else
        {
            [[cell textLabel] setText:@""]; //  Empty the text in case of recycled cells.
        }
        
        //  Clear accessories.
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    /* ...otherwise, we'll show the data for the category. */
    else
    {
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Row Counts

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
    else if (selectedIndex == [[[self dataSource] repos] count])
    {
        rowCount = [[[self dataSource] repos] count];
    }
    
    return rowCount;
}


@end
