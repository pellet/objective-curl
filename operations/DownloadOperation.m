//
//  DownloadOperation.m
//  objective-curl
//
//  Created by Ben Pettit on 15/02/13.
//  Digimulti PTY LTD 2013
//

#import "DownloadOperation.h"
#import "FileTransfer.h"

@implementation DownloadOperation

@synthesize download=_download;

/*
 * Thread entry point for recursive HTTP downloads.
 */
- (void)main
{
	if ([self isCancelled] || [self dependentOperationCancelled]) {
		
		[self notifyDelegateOfFailure];
		
		return;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
        // Set options for downloading
//	curl_easy_setopt(handle, CURLOPT_UPLOAD, 1L);
    curl_easy_setopt(handle, CURLOPT_HTTPGET, 1L);
	curl_easy_setopt(handle, CURLOPT_PROGRESSDATA, self);
	curl_easy_setopt(handle, CURLOPT_PROGRESSFUNCTION, handleDownloadProgress);
	
        // Set interface specific auth options
	[self setProtocolSpecificOptions];
	
	double totalBytes = 0;
	
//        // Enumurate files and directories to upload
//	NSArray *filesToUpload = [[self enumerateFilesToUpload:[upload localFiles]
//													prefix:[upload path]
//												totalBytes:&totalBytes] retain];
//	
//	[upload setTransfers:filesToUpload];
    
//	[upload setTotalFiles:[filesToUpload count]];
//	[self.download setTotalFilesDownloaded:0];
    
	[self.download setTotalBytes:totalBytes];
	[self.download setTotalBytesDownloaded:0];
	
    
	CURLcode result = -1;
	
	for (int i = 0; i < [filesToUpload count]; i++) {
            // Begin Uploading.
		FileTransfer *file = [filesToUpload objectAtIndex:i];
		
		[self.download setCurrentTransfer:file];
		
		if ([file fileNotFound]) {
			NSLog(@"Local file not found: %@", [file localPath]);
			continue;
        }
		
		[self setFileSpecificOptions:file];
		
		FILE *fh = [file getHandle];
		
		NSString *url = [self urlForTransfer:file];
		
		curl_easy_setopt(handle, CURLOPT_READDATA, fh);
		curl_easy_setopt(handle, CURLOPT_INFILESIZE_LARGE, (curl_off_t)[file totalBytes]);
		curl_easy_setopt(handle, CURLOPT_URL, [url UTF8String]);
		
            // Perform
		result = curl_easy_perform(handle);
		
            // Cleanup any headers
		[file cleanupHeaders];
		
            // Cleanup any quote commands
		[file cleanupPostQuotes];
		
            // Close the file handle
		fclose(fh);
		
            // If this upload wasn't successful, bail out.
		if (result != CURLE_OK)
			break;
		
            // Increment total files uploaded
		[self.download setTotalFilesUploaded:i + 1];
    }
	
        // Cleanup Curl
	curl_easy_cleanup(handle);
	
        // Cleanup the files array.
	[filesToUpload release];
    
        // Process the result of the upload.
	[self handleUploadResult:result];
	
        // Done.
	[pool release];
}

/*
 * Used to handle upload progress if the showProgress flag is set. Invoked by libcurl on progress updates to calculates the
 * new upload progress and sets it on the upload.
 *
 *      See http://curl.haxx.se/libcurl/c/curl_easy_setopt.html#CURLOPTPROGRESSFUNCTION
 */
static int handleDownloadProgress(DownloadOperation *operation, int connected, double dltotal, double dlnow, double ultotal, double ulnow)
{
	Download *download = [operation download];
	
	if ([download connected] && !connected) return 0;  // Reconnecting...
	
	if (!connected) {
		if ([download status] != TRANSFER_STATUS_CONNECTING) {
                // Connecting ...
			[download setConnected:NO];
			[download setStatus:TRANSFER_STATUS_CONNECTING];
			
                // Notify the delegate
			[operation performDelegateSelector:@selector(curlIsConnecting:) withArgument:nil];
        }
		
    } else {
		if (![download connected]) {
                // We have a connection.
			[download setConnected:YES];
			[download setStatus:TRANSFER_STATUS_CONNECTED];
			
                // Notify the delegate
			[operation performDelegateSelector:@selector(curlDidConnect:) withArgument:nil];
        }
		
        if ([download connected] && [download status] != TRANSFER_STATUS_UPLOADING && ulnow > 0) {
			[download setStatus:TRANSFER_STATUS_UPLOADING];
            
                // Notify the delegate
			[operation performDelegateSelector:@selector(uploadDidBegin:) withArgument:nil];
            
                // Start the BPS timer
			[operation startByteTimer];
        }
		
		if (ulnow > ultotal) return 0;		// This happens occasionally, not sure why...
		
		[operation calculateUploadProgress:ulnow total:ultotal];
    }	
	
	return ([download cancelled] || [download status] == TRANSFER_STATUS_FAILED);
}

@end
