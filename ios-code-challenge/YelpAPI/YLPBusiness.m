//
//  YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "YLPBusiness.h"

@implementation YLPBusiness

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
  if(self = [super init]) {
    NSDictionary *coordinates = attributes[@"coordinates"];

    _distance = attributes[@"distance"];
    _identifier = attributes[@"id"];
    _imageUrl = attributes[@"image_url"];
    _name = attributes[@"name"];
    _price = attributes[@"price"];
    _rating = attributes[@"rating"];
    _reviewCount = attributes[@"review_count"];
    _categories = [self.class categoriesFromJSONArray:attributes[@"categories"]];
    _latitude = coordinates[@"latitude"];
    _longitude = coordinates[@"longitude"];
  }
  
  return self;
}

- (instancetype)initWithVariables: (NSString *)name :(NSString *)imageUrl :(NSString *)price : (NSNumber *)rating :(NSString *)identifier :(NSNumber *)reviewCount :(NSString *)categories :(NSNumber *)latitude :(NSNumber *)longitude
{
  if(self = [super init]) {
    _identifier = identifier;
    _imageUrl = imageUrl;
    _name = name;
    _price = price;
    _rating = rating;
    _reviewCount = reviewCount;
    _categories = categories;
    _latitude = latitude;
    _longitude = longitude;
  }
  
  return self;
}

+ (NSString *)categoriesFromJSONArray:(NSArray *)categoriesJSON
{
  NSMutableString *mutableCategoriesJSON = [[NSMutableString alloc] init];
  
  for (NSDictionary *categories in categoriesJSON) {
    if (categories != categoriesJSON.firstObject)
      [mutableCategoriesJSON appendString: @", "];
    
    [mutableCategoriesJSON appendString: categories[@"title"]];
  }
  
  return mutableCategoriesJSON;
}

@end
