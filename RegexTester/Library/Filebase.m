//
//  Filebase.m
//  RegexTester
//
//  Created by James Womack on 2/7/13.
//
//

#import "Filebase.h"

#pragma mark implementation

#pragma mark -strings
NSString* const FilebaseErrorCodeItemNotFoundString = @"Item not found";
NSString* const FilebaseErrorCodeItemTypeUnexpectedString = @"Item is not directory";


#pragma mark -functions


NSString* _bundlePath_(NSString* aPath)
{
    return [NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:aPath];
}

NSArray* _bundleContents_(NSString* aPath)
{
    return _contents_(_bundlePath_(aPath));
}

NSArray* _contents_(NSString* aPath)
{
    NSArray* contents = nil;
    NSError* error = nil;
    BOOL isDirectory;
    
    BOOL itemExistsAtPath = [NSFileManager.defaultManager fileExistsAtPath:aPath isDirectory:&isDirectory];
    
    if (!itemExistsAtPath)
    {
        error = [NSError errorWithDomain:@"FilebaseErrorDomain" code:FilebaseErrorCodeItemNotFound userInfo:[NSDictionary dictionaryWithObject:FilebaseErrorCodeItemNotFoundString forKey:NSLocalizedDescriptionKey]];
    }
    else if (!isDirectory)
    {
        error = [NSError errorWithDomain:@"FilebaseErrorDomain" code:FilebaseErrorCodeItemTypeUnexpected userInfo:[NSDictionary dictionaryWithObject:FilebaseErrorCodeItemTypeUnexpectedString forKey:NSLocalizedDescriptionKey]];
    }
    else
    {
        contents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:aPath error:&error];
    }
    
    if (error)
    {
        NSLog(@"%@",error);
    }
    
    return contents;
}

Filebase* initializeFilebase(void)
{
    Filebase* filebase = (Filebase*)malloc(sizeof(Filebase));
    filebase->bundleContents = _bundleContents_;
    filebase->bundlePath = _bundlePath_;
    filebase->contents = _contents_;
    return filebase;
}


