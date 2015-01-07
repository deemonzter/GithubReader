//
//  Utils.h
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (NSDate *)dateFromString:(NSString *)stringDate;

+ (NSString *)prettyStringFromDate:(NSDate *)date;

@end
