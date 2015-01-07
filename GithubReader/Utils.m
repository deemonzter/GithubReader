//
//  Utils.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "Utils.h"
@import UIKit;

@implementation Utils

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

+ (NSDate *)dateFromString:(NSString *)stringDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date = [dateFormatter dateFromString:stringDate];
    return date;
}

+ (NSString *)prettyStringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:date];
}

@end