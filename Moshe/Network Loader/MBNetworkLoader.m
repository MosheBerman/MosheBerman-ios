//
//  MBNetworkLoader.m
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBNetworkLoader.h"

@interface MBNetworkLoader ()  <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSNumber *expectedFileSize;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) MBDataLoaderCompletion completion;

@end

@implementation MBNetworkLoader

- (id)initWithURL:(NSURL *)url completion:(MBDataLoaderCompletion)completion
{
    self = [super init];
    if (self)
    {
        _url = url;
        _completion = completion;
        
        // Create the request.
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:NO];
        
        _connection = theConnection;
        
        if (theConnection)
        {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            [self setData: [NSMutableData data]];
        }
        else
        {
            [self connection:theConnection didFailWithError:nil];
        }
        
    }
    return self;
}

- (void) start
{
    [[self connection] start];
}

//  Allow external objects to cancel the completion block
- (void) cancelCompletion
{
    [self setCompletion:nil];
}

#pragma mark - Progress


- (double)progress
{
    double expectedSize = [self.expectedFileSize floatValue];
    double complete = self.data.length;
    
    if (!(expectedSize > 0))
    {
        return 0;
    }
    
    return  (complete/expectedSize)*100.0;
}

#pragma mark - NSURLConnectionDelegate

/* Set up the response when appropriate  */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [[self data] setLength:0];
    
    NSNumber *expectedSize = [NSNumber numberWithLongLong:[response expectedContentLength]];
    
    [self setExpectedFileSize:expectedSize];
    
    if ([[self expectedFileSize] longLongValue] == NSURLResponseUnknownLength)
    {
        //Unknown length of file...
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self data] appendData:data];
}

/* */

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    if ([self completion]) {
        MBDataLoaderCompletion completion = [self completion];
        completion(nil);
    }
}

/* When the download finishes, execute the block */

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        if ([self completion])
        {
            MBDataLoaderCompletion completion = [self completion];
            completion([self data]);
        }
}

@end
