//
//  MBDataSource.m
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBDataSource.h"

#import "MBURLConstants.h"

#import "MBNetworkLoader.h"

#import "MBAppData.h"
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
    [self setNetworkLoaders:[NSMutableArray new]];
    
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
        MBAppData *app = [MBAppData new];
        
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
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dictionary in JSON) {
        MBRepoData *repo = [MBRepoData new];
        
        [repo setName:dictionary[@"name"]];
        [repo setHtmlURL:dictionary[@"html_url"]];
        [repo setRepoDescription:dictionary[@"description"]];
        
        [[self repos] addObject:repo];
    }
    
    [self setAreReposReady:YES];
}

- (void)processRepos:(NSData *)data
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dictionary in JSON) {
        MBRepoData *repo = [MBRepoData new];
        
        
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
