//
//  Mx80211.m
//

//  Copyright (C) 2012 http://github.com/iosdeveloper
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "Mx80211.h"

@implementation Mx80211

@synthesize infoDict;

- (id)init {
    self = [super init];
    
    libHandle = dlopen("/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration", RTLD_LAZY);
    
    char *error;
    
    if (libHandle == NULL && (error = dlerror()) != NULL)  {
        NSLog(@"%s", error);
        exit(1);
    }
    
    apple80211Open = dlsym(libHandle, "Apple80211Open");
    apple80211Bind = dlsym(libHandle, "Apple80211BindToInterface");
    apple80211Close = dlsym(libHandle, "Apple80211Close");
    apple80211GetInfoCopy = dlsym(libHandle, "Apple80211GetInfoCopy");
    
    apple80211Open(&airportHandle);
    apple80211Bind(airportHandle, @"en0");
    
    CFDictionaryRef info = NULL;
    
    apple80211GetInfoCopy(airportHandle, &info);
    
    self.infoDict = (__bridge NSDictionary *)info;
    
    apple80211Close(airportHandle);
    
    return self;
}

@end
