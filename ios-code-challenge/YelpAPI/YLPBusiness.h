//
//  YLPBusiness.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface YLPBusiness : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

- (instancetype)initWithVariables: (NSString *)name :(NSString *)imageUrl :(NSString *)price : (NSNumber *)rating :(NSString *)identifier :(NSNumber *)reviewCount;

/**
 *  Yelp categories of this business.
 */
@property (nonatomic, readonly, copy) NSString *categories;

/**
 *  Yelp Latitude position of map bounds center for this business.
 */
@property (nonatomic, readonly, copy) NSNumber *latitude;

/**
 *  Yelp  Longintude position of map bounds center for this business.
 */
@property (nonatomic, readonly, copy) NSNumber *longitude;

/**
 *  Yelp distance of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *distance;

/**
 *  Yelp image of this business.
 */
@property (nonatomic, readonly, copy) UIImage *image;

/**
 *  Yelp id of this business.
 */
@property (nonatomic, readonly, copy) NSString *identifier;

/**
 *  Yelp price of this business.
 */
@property (nonatomic, readonly, copy) NSString *price;

/**
 *  Yelp rating of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *rating;

/**
 *  Yelp review count of this business.
 */
@property (nonatomic, readonly, copy) NSNumber *reviewCount;

/**
 *  Yelp imageUrl of this business.
 */
@property (nonatomic, readonly, copy) NSString *imageUrl;

/**
 *  Name of this business.
 */
@property (nonatomic, readonly, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
