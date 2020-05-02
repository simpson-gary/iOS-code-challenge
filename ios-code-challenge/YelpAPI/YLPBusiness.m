//
//  YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPBusiness.h"

@implementation YLPBusiness

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
  if(self = [super init]) {
    _distance = attributes[@"distance"];
    _identifier = attributes[@"id"];
    _imageUrl = attributes[@"image_url"];
    _name = attributes[@"name"];
    _price = attributes[@"price"];
    _rating = attributes[@"rating"];
    _reviewCount = attributes[@"review_count"];
    _categories = [self.class categoriesFromJSONArray:attributes[@"categories"]];
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
