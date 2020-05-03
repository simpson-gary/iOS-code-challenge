//
//  YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import <UIKit/UIKit.h>
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
    //_image = [self.class imageFromUrl:attributes[@"image_url"]];
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

//+ (UIImage *)imageFromUrl:(NSString *)url
//{
// // __block UIImage *image = [[UIImage alloc] init];
//  
// dispatch_async(dispatch_get_global_queue(0,0), ^{
//      NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
//    if ( data == nil ) {
//      NSLog(@"URL is nil");
//          return;
//    }
//    UIImage* image = [UIImage imageWithData:data];
//      dispatch_async(dispatch_get_main_queue(), ^{
//          // WARNING: is the cell still using the same data by this point??
//
//        //NSLog(@"Setting image is %f", image.size.height);
//        return image;
//        
//        //NSLog(@"Setting image is %f", image.size.height);
//      });
//  });
//  
//  return nil;
//}

@end
