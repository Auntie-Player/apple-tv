//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Phillip Caudell & Matthew Cheetham
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

- (NSString *)ISO8601String
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    return [dateFormatter stringFromDate:self];
}

+ (instancetype)dateWithISO86SomethingString:(NSString *)string
{
    NSString *dateFormatString = @"yyyy-MM-dd'T'HH:mm:ss'.000Z'";

    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:dateFormatString];
    
    if ([dateFormat dateFromString:string]) {
        return [dateFormat dateFromString:string];
    }
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    return [dateFormat dateFromString:string];
}

+ (instancetype)dateWithISO8601String:(NSString *)string
{
    return [NSDate dateWithISO8601String:string considerLocale:YES];
}

+ (instancetype)dateWithISO8601String:(NSString *)string considerLocale:(BOOL)considerLocale
{
    NSString *dateFormatString;
    
    if (considerLocale) {
        
        dateFormatString = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
        
    } else {
        
        dateFormatString = @"yyyy-MM-dd";
    }
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:dateFormatString];
    
    if ([dateFormat dateFromString:string]) {
        return [dateFormat dateFromString:string];
    }
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    return [dateFormat dateFromString:string];
}

@end
