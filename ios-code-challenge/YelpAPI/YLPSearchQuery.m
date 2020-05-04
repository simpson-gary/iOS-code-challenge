//
//  YLPSearchQuery.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "YLPSearchQuery.h"

@interface YLPSearchQuery()

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) CLLocation *coordinates;

@end

@implementation YLPSearchQuery

- (instancetype)initWithLocation:(NSString *)location
{
    if(self = [super init]) {
        _location = location;
    }
    
    return self;
}

- (instancetype)initWithCoordinates:(CLLocation *)coordinates
{
    if(self = [super init]) {
      _coordinates = coordinates;
    }
    
    return self;
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(self.location) {
        params[@"location"] = self.location;
    }
  
    if(self.coordinates) {
      params[@"longitude"] = [NSString stringWithFormat:@"%.20lf", self.coordinates.coordinate.longitude];
      params[@"latitude"] = [NSString stringWithFormat:@"%.20lf", self.coordinates.coordinate.latitude];
    }
  
    if(self.offset) {
      params[@"offset"] = self.offset;
    }
  
    if(self.limit) {
      params[@"limit"] = self.limit;
    }
  
    if(self.term) {
        params[@"term"] = self.term;
    }
    
    if(self.radiusFilter > 0) {
        params[@"radius"] = @(self.radiusFilter);
    }
    
    if(self.categoryFilter != nil && self.categoryFilter.count > 0) {
        params[@"categories"] = [self.categoryFilter componentsJoinedByString:@","];
    }
  
    return params;
}

- (NSArray<NSString *> *)categoryFilter {
    return _categoryFilter ?: @[];
}

@end
