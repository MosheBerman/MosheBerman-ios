//
//  MBDataSource.m
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

/* Classes */
#import "MBDataSource.h"
#import "MBNetworkLoader.h"

/* Constants */
#import "MBURLConstants.h"

/* Model objects. */
#import "MBAppData.h"
#import "MBBlogPostData.h"
#import "MBRepoData.h"

@interface MBDataSource ()

@property (nonatomic, strong) NSMutableArray *networkLoaders;

@end

@implementation MBDataSource

- (id)init
{
    self = [super init];
    if (self) {
        
        _apps = [[NSMutableArray alloc] init];
        _blogPosts = [[NSMutableArray alloc] init];
        _repos = [[NSMutableArray alloc] init];
        
        _networkLoaders = [[NSMutableArray alloc] init];
        
        _areAppsReady = NO;
        _areBlogPostsReady = NO;
        _areReposReady = NO;
    }
    return self;
}

#pragma mark - Reload

- (void)reloadData
{

    /* Clean old loaders */
    for (MBNetworkLoader *loader in [self networkLoaders])
    {
        [loader cancelCompletion];
    }

    [self setNetworkLoaders:nil];
    
    /* Set up new ones, one per category */
    [self setNetworkLoaders:[[NSMutableArray alloc] init]];
    
    MBNetworkLoader *appsLoader = [[MBNetworkLoader alloc] initWithURL:[NSURL URLWithString:kAppsURL] completion:^(NSData *data) {
        if (!data) {
            return;
        }
        [self processApps:data];
    }];
    
    
    MBNetworkLoader *blogLoader = [[MBNetworkLoader alloc] initWithURL:[NSURL URLWithString:kBlogPostsURL] completion:^(NSData *data) {
        if (!data) {
            return;
        }
        [self processBlogPosts:data];
    }];
    
    MBNetworkLoader *reposLoader = [[MBNetworkLoader alloc] initWithURL:[NSURL URLWithString:kReposURL] completion:^(NSData *data) {
        if (!data) {
            return;
        }
        [self processRepos:data];
    }];
    
    /* Hang on to the network loaders. */
    [[self networkLoaders] addObject:appsLoader];
    [[self networkLoaders] addObject:reposLoader];
    [[self networkLoaders] addObject:blogLoader];
    
    [appsLoader start];
    [reposLoader start];
}

#pragma mark - KVO

- (void)setAreAppsReady:(BOOL)areAppsReady
{
    [self willChangeValueForKey:@"areAppsReady"];
    _areAppsReady = areAppsReady;
    [self didChangeValueForKey:@"areAppsReady"];
}

- (void)setAreBlogPostsReady:(BOOL)areReposReady
{
    [self willChangeValueForKey:@"areBlogPostsReady"];
    _areBlogPostsReady = areReposReady;
    [self didChangeValueForKey:@"areBlogPostsReady"];
}

- (void)setAreReposReady:(BOOL)areReposReady
{
    [self willChangeValueForKey:@"areReposReady"];
    _areReposReady = areReposReady;
    [self didChangeValueForKey:@"areReposReady"];
}

#pragma mark - Process Data

- (void)processApps:(NSData *)data
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dictionary in JSON) {
        MBAppData *app = [[MBAppData alloc] init];
        
        [app setAppDescription:dictionary[@"app_description"]];
        [app setName:dictionary[@"app_name"]];
        [app setAppURL:dictionary[@"app_link"]];
        [app setImageURL:dictionary[@"app_image_link"]];
        [app setAppID:dictionary[@"app_id"]];
        [app setVersion:dictionary[@"app_version"]];
        
        [[self apps] addObject:app];
    }
    
    [self setAreAppsReady:YES];
}

- (void)processBlogPosts:(NSData *)data
{
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //
    NSArray *posts = JSON[@"posts"];
    
    for (NSDictionary *dictionary in posts)
    {
        MBBlogPostData *post = [[MBBlogPostData alloc] init];
        
        /* Process post's tags. */
        NSMutableArray *tags = [[NSMutableArray alloc] init];
        
        for (NSDictionary *tagData in dictionary[@"tags"])
        {
            NSString *tagName = tagData[@"title"];
            [tags addObject:tagName];
        }
        
        /* Process post's tags. */
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        
        for (NSDictionary *categoryData in dictionary[@"categories"])
        {
            NSString *categoryName = categoryData[@"title"];
            [categories addObject:categoryName];
        }
        
        /* Prepare the URL. */
        NSURL *url = [NSURL URLWithString:dictionary[@"url"]];
        
        [post setPostID:dictionary[@"id"]];
        [post setSlug:dictionary[@"slug"]];
        [post setURL:url];
        [post setTitle:dictionary[@"title"]];
        [post setContent:dictionary[@"content"]];
        [post setTags:tags];
        [post setCategories:categories];
        
        [[self blogPosts] addObject:post];
    }
    
    [self setAreBlogPostsReady:YES];
}

- (void)processRepos:(NSData *)data
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dictionary in JSON) {
        MBRepoData *repo = [[MBRepoData alloc] init];
        
        [repo setName:dictionary[@"name"]];
        [repo setHtmlURL:dictionary[@"html_url"]];
        [repo setRepoDescription:dictionary[@"description"]];
        
        [[self repos] addObject:repo];
    }
    
    [self setAreReposReady:YES];
}

/* Hacky way to consume API data, assuming keys and property names are identical */
- (SEL)setterFromKey:(NSString *)key
{
    return NSSelectorFromString([NSString stringWithFormat:@"set%@",[key capitalizedString]]);
}

@end
