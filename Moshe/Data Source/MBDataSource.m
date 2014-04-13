//
//  MBDataSource.m
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBDataSource.h"

#import "MBURLConstants.h"

#import "MOSApp.h"
#import "MOSBlogPost.h"
#import "MOSRepo.h"
#import "MOSBanner.h"

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
        _banners = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Reload

- (void)reloadDataWithCompletion:(MBDataSourceCompletionBlock)completion
{
    NSURLRequest *appsRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kAppsURL]];
    NSURLRequest *blogRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kBlogPostsURL]];
    NSURLRequest *reposRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:kReposURL]];
    
    [NSURLConnection sendAsynchronousRequest:appsRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data)
        {
            [self processApps:data];
            
            if (completion)
            {
                completion();
            }
        }
    }];
    
    [NSURLConnection sendAsynchronousRequest:blogRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data)
        {
            [self processBlogPosts:data];
            if (completion)
            {
                completion();
            }
        }
    }];
    
    [NSURLConnection sendAsynchronousRequest:reposRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data)
        {
            [self processRepos:data];
            if (completion)
            {
                completion();
            }
        }
    }];
    
}


/**
 *  This method downloads the banners.
 */

- (void)loadBannersWithCompletion:(MBDataSourceCompletionBlock)completion
{
    
    NSURL *url = [NSURL URLWithString:kBannersURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data)
        {
            [self processBanners:data];
        }
        
        if (completion)
        {
            completion();
        }
        
    }];
}


#pragma mark - Process Data

- (void)processApps:(NSData *)data
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dictionary in JSON) {
        MOSApp *app = [[MOSApp alloc] init];
        
        NSURL *url = [NSURL URLWithString:dictionary[@"app_link"]];
        
        [app setAppDescription:dictionary[@"app_description"]];
        [app setName:dictionary[@"app_name"]];
        [app setAppURL:url];
        [app setImageURL:dictionary[@"app_image_link"]];
        [app setAppID:dictionary[@"app_id"]];
        [app setVersion:dictionary[@"app_version"]];
        
        [[self apps] addObject:app];
    }
}

- (void)processBlogPosts:(NSData *)data
{
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //
    NSArray *posts = JSON[@"posts"];
    
    for (NSDictionary *dictionary in posts)
    {
        MOSBlogPost *post = [[MOSBlogPost alloc] init];
        
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
}

- (void)processRepos:(NSData *)data
{
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dictionary in JSON) {
        MOSRepo *repo = [[MOSRepo alloc] init];
        
        NSURL *url = [NSURL URLWithString:dictionary[@"html_url"]];
        
        [repo setName:dictionary[@"name"]];
        [repo setHtmlURL:url];
        [repo setRepoDescription:dictionary[@"description"]];
        
        [[self repos] addObject:repo];
    }
}

- (void)processBanners:(NSData *)data
{
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *banners = JSON[@"banners"];
    
    for (NSDictionary *dictionary in banners)
    {
        MOSBanner *banner = [[MOSBanner alloc] init];
        
        NSURL *url = [NSURL URLWithString:dictionary[@"url"]];
        NSURL *imageURL = [NSURL URLWithString:dictionary[@"mobile_banner"]];
        
        [banner setUrl:url];
        [banner setImageURL:imageURL];
        [banner setTitle:dictionary[@"title"]];
        
        [[self banners] addObject:banner];
    }
}

@end
