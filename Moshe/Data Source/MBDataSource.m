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
        
        _apps = [NSMutableArray new];
        _repos = [NSMutableArray new];
        
        _networkLoaders =[NSMutableArray new];
        
        _areAppsReady = NO;
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
    
    /* Set up two new ones */
    [self setNetworkLoaders:[NSMutableArray new]];
    
    MBNetworkLoader *appsLoader = [[MBNetworkLoader alloc] initWithURL:[NSURL URLWithString:kAppsURL] completion:^(NSData *data) {
        if (!data) {
            return;
        }
        [self processApps:data];
    }];
    
    
    MBNetworkLoader *reposLoader = [[MBNetworkLoader alloc] initWithURL:[NSURL URLWithString:kReposURL] completion:^(NSData *data) {
        if (!data) {
            return;
        }
        [self processRepos:data];
    }];
    
    [[self networkLoaders] addObject:appsLoader];
    [[self networkLoaders] addObject:reposLoader];
    
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

- (void)processRepos:(NSData *)data
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dictionary in JSON) {
        MBRepoData *repo = [MBRepoData new];
        
        [repo setName:dictionary[@"name"]];
        [repo setHtmlURL:dictionary[@"html_url"]];
        [repo setDescription:dictionary[@"description"]];
        
        [[self repos] addObject:repo];
    }
    
    [self setAreReposReady:YES];
}

/* Hacky way to consume API dat, assuming keys and property names are identical */
- (SEL)setterFromKey:(NSString *)key
{
    return NSSelectorFromString([NSString stringWithFormat:@"set%@",[key capitalizedString]]);
}

@end
