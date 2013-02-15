//
//  CurlHTTP.m
//  objective-curl
//
//  Created by eggers on 15/02/13.
//
//

#import "CurlHTTP.h"
#import "Upload.h"
#import "Download.h"
#import "CurlClientType.h"
#import "DownloadOperation.h"

@implementation CurlHTTP

- (NSString *)protocolPrefix
{
	return @"http";
}


- (int)defaultPort
{
	return 80;
}

- (int)clientType
{
	return CURL_CLIENT_HTTP;
}

- (Download *)downloadFile:(NSString *)file toHost:(NSString *)hostname username:(NSString *)username
{
    return [self downloadFile:file
                       toHost:hostname
                     username:username
                     password:@""];
}

- (Download *)downloadFile:(NSString *)file toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password
{
    return [self downloadFile:file
                        toHost:hostname
                      username:username
                      password:password
                     directory:@""];
}

- (Download *)downloadFile:(NSString *)file toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password directory:(NSString *)directory
{
    return [self downloadFile:file
                       toHost:hostname
                     username:username
                     password:password
                    directory:directory
                         port:[self defaultPort]];
}

- (Download *)downloadFile:(NSString *)file toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password directory:(NSString *)directory port:(int)port
{
    Download *download = [[Download new] autorelease];
	
	[download setProtocol:[self protocol]];
	[download setProtocolPrefix:[self protocolPrefix]];
	[download setClientType:[self clientType]];
        //	[upload setLocalFiles:filesAndDirectories];
    [download setLocalFiles:directory];
	[download setHostname:hostname];
	[download setUsername:username];
	[download setPassword:password];
//	[download setPath:[directory stringByRemovingTildePrefix]];
	[download setPath:file];
	[download setPort:port];
    
	[self download:download];
    
    return download;
}

- (void)download:(Download *)record
{
	DownloadOperation *op = [[DownloadOperation alloc] initWithHandle:[self newHandle] delegate:delegate];
    
	[record setProgress:0];
	[record setStatus:TRANSFER_STATUS_QUEUED];
	[record setConnected:NO];
	[record setCancelled:NO];
    
	[op setUpload:record];
	[operationQueue addOperation:op];
	[op release];
}

#pragma mark Undefined functions
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username{return nil;}
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password{return nil;}
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password directory:(NSString *)directory{return nil;}
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password directory:(NSString *)directory port:(int)port{return nil;}
- (void)upload:(Upload *)record{}

@end
