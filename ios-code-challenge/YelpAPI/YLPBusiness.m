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
    _rating = attributes[@"rating"];
    _reviewCount = attributes[@"review_count"];
    _categories = [self.class categoriesFromJSONArray:attributes[@"categories"]];
  }
  
  return self;
}

+ (NSString *)categoriesFromJSONArray:(NSArray *)categoriesJSON
{
  NSMutableString *mutableCategoriesJSON = [[NSMutableString alloc] init];
    
    for (NSArray *string in categoriesJSON) {
      if (mutableCategoriesJSON != nil) {
        mutableCategoriesJSON = "";//mutableCategoriesJSON + ", " + string;
      };
    }
    
    return mutableCategoriesJSON;
}

@end
