//
//  SGFormatFactory.h
//  SGMediaKit
//
//  Created by Single on 06/12/2016.
//  Copyright © 2016 single. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SGFormatQualityType) {
    SGFormatQualityTypeLow,
    SGFormatQualityTypeMedium,
    SGFormatQualityTypeHighest,
};

@interface SGFormatFactory : NSObject

+ (BOOL)isReady;

+ (void)mpeg4FormatWithSourceFileURL:(NSURL *)sourceFileURL
                  destinationFileURL:(NSURL *)destinationFileURL
                         qualityType:(SGFormatQualityType)qualityType
                     progressHandler:(void(^)(float progress))progressHandler
                   completionHandler:(void(^)(NSError * error))completionHandler;

@end