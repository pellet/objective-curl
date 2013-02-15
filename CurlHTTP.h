//
//  CurlHTTP.h
//  objective-curl
//
//  Created by eggers on 15/02/13.
//
//

#import "CurlObject.h"
#import "CurlClient.h"

@class Download;

@interface CurlHTTP : CurlObject <CurlClient>

- (NSString *)protocolPrefix;
- (int)defaultPort;

- (Download *)downloadFile:(NSString *)file toHost:(NSString *)hostname username:(NSString *)username;

@end
