//
//  NXTBusinessTableViewCell+YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "NXTBusinessTableViewCell+YLPBusiness.h"
#import "YLPBusiness.h"
#import <ios_code_challenge-Swift.h>

@implementation NXTBusinessTableViewCell (YLPBusiness) 

- (void)configureCell:(YLPBusiness *)business
{
      
  //NSLog(@"URL is %@", business.imageUrl);
  dispatch_async(dispatch_get_global_queue(0,0), ^{
      NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: business.imageUrl]];
    if ( data == nil ) {
      NSLog(@"URL is nil");
          return;
    }
    
      dispatch_async(dispatch_get_main_queue(), ^{
          // WARNING: is the cell still using the same data by this point??

          //NSLog(@"setting image");
          self.businessImage.image = [UIImage imageWithData: data];
      });
  });
  
  
  // Business Name
    self.business = business;
//    NSLog(@"Distance is %@", business.distance);
//  self.detailTextLabel.text = [NSString stringWithFormat:@"%@ ~ rating=%@", business.distance, business.rating];
  //self.accessoryType = UITableViewCellAccessoryDetailButton;
}

#pragma mark - NXTBindingDataForObjectDelegate
- (void)bindingDataForObject:(id)object
{
    [self configureCell:(YLPBusiness *)object];
}

@end
