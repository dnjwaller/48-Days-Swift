//
//  loadFeed.h
//  Days
//
//  Created by Dan Waller on 8/12/13.
//
//

#import <Foundation/Foundation.h>

@interface loadFeed : NSObject {
     NSDictionary *items;
}

 @property (strong, nonatomic) NSDictionary *items;

-(NSDictionary *) loadData:(NSString *)url;

@end
