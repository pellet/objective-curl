//
//  DownloadOperation.h
//  objective-curl
//
//  Created by eggers on 15/02/13.
//
//

#import "CurlOperation.h"

@class Download;

@interface DownloadOperation : CurlOperation
{
	Download *_download;
}

@property(readwrite, retain) Download *download;

static int handleDownloadProgress(DownloadOperation *operation, int connected, double dltotal, double dlnow, double ultotal, double ulnow);

@end
