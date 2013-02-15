/*
 *  CurlClientType.h
 *  objective-curl
 *
 *  Copyright 2010 Nick Jensen <http://goto11.net>
 *
 */


typedef enum {
	CURL_CLIENT_SFTP,
	CURL_CLIENT_FTP,
	CURL_CLIENT_S3,
    CURL_CLIENT_HTTP,
    CURL_CLIENT_HTTPS
} CurlClientType;