//
//  ViewController.m
//  CertificationExample
//
//  Created by heleiwu on 9/27/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>

#define CC_SHA256_DIGEST_LENGTH		32			/* digest length in bytes */
typedef uint32_t CC_LONG;		/* 32 bit unsigned integer */
typedef uint64_t CC_LONG64;		/* 64 bit unsigned integer */
extern unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self extractCertification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)extractCertification {
    OSStatus err;
    SecCertificateRef serverCert;
    SecIdentityRef serverIdentity;
    SecTrustRef serverTrust;
    SecKeyRef publicKey;
    SecKeyRef privatekey;
    
    NSString *serverP12Path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"p12"];
    NSData *serverP12Data = [NSData dataWithContentsOfFile:serverP12Path];
    err = extractIdentityAndTrust((__bridge CFDataRef)serverP12Data, &serverIdentity, &serverTrust, (__bridge CFStringRef)@"9999");
    
    if (err == errSecSuccess) {
        NSLog(@"Copy certification information success!");
    } else {
        NSLog(@"Copy certification information failed!");
    }
    
    NSLog(@"Getting certification ...");
    err = SecIdentityCopyCertificate(serverIdentity, &serverCert);
    if (err == errSecSuccess) {
        NSLog(@"Getting certification success!");
    } else {
        NSLog(@"Getting certification failed!");
    }
    
    err = SecIdentityCopyPrivateKey(serverIdentity, &privatekey);
    publicKey = SecTrustCopyPublicKey(serverTrust);

    NSString *plainStr = [NSString stringWithFormat:@"helewu|%lld", 333LL];
    NSData *plainData = [plainStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signature = PKCSSignBytesSHA256withRSA(plainData, privatekey);
    if (PKCSVerifyBytesSHA256withRSA(plainData, signature, publicKey)) {
        NSLog(@"Verified passed!");
    } else {
        NSLog(@"Verified failed!");
    }
    
}

NSData* PKCSSignBytesSHA256withRSA(NSData* plainData, SecKeyRef privateKey)
{
    size_t signedHashBytesSize = SecKeyGetBlockSize(privateKey);
    uint8_t* signedHashBytes = malloc(signedHashBytesSize);
    memset(signedHashBytes, 0x0, signedHashBytesSize);
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
    }
    
    SecKeyRawSign(privateKey,
                  kSecPaddingPKCS1SHA256,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);
    
    NSData* signedHash = [NSData dataWithBytes:signedHashBytes
                                        length:(NSUInteger)signedHashBytesSize];
    
    if (hashBytes)
    free(hashBytes);
    if (signedHashBytes)
    free(signedHashBytes);
    
    return signedHash;
}

BOOL PKCSVerifyBytesSHA256withRSA(NSData* plainData, NSData* signature, SecKeyRef publicKey)
{
    size_t signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

OSStatus extractIdentityAndTrust(CFDataRef inPKCS12Data,
                                 SecIdentityRef *outIdentity,
                                 SecTrustRef *outTrust,
                                 CFStringRef keyPassword)
{
    OSStatus securityError = errSecSuccess;
    
    
    const void *keys[] =   { kSecImportExportPassphrase };
    const void *values[] = { keyPassword };
    CFDictionaryRef optionsDictionary = NULL;
    
    /* Create a dictionary containing the passphrase if one
     was specified.  Otherwise, create an empty dictionary. */
    optionsDictionary = CFDictionaryCreate(
                                           NULL, keys,
                                           values, (keyPassword ? 1 : 0),
                                           NULL, NULL);  // 1
    
    CFArrayRef items = NULL;
    securityError = SecPKCS12Import(inPKCS12Data,
                                    optionsDictionary,
                                    &items);                    // 2
    
    
    //
    if (securityError == 0) {                                   // 3
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust,
                                             kSecImportItemIdentity);
        CFRetain(tempIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        
        CFRetain(tempTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }
    
    if (optionsDictionary)                                      // 4
    CFRelease(optionsDictionary);
    
    if (items)
    CFRelease(items);
    
    return securityError;
}

@end
