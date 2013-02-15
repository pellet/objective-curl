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

@implementation CurlHTTP

- (NSString *)protocolPrefix
{
	return @"http";
}


- (int)defaultPort
{
	return 80;
}

- (Download *)downloadFile:(NSString *)file toHost:(NSString *)hostname username:(NSString *)username
{
    
}

- (void)download:(Download *)record
{
    
}

#pragma mark Undefined functions
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username{return nil;}
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password{return nil;}
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password directory:(NSString *)directory{return nil;}
- (Upload *)uploadFilesAndDirectories:(NSArray *)filesAndDirectories toHost:(NSString *)hostname username:(NSString *)username password:(NSString *)password directory:(NSString *)directory port:(int)port{return nil;}
- (void)upload:(Upload *)record{}

@end
