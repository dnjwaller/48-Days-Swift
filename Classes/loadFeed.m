//
//  loadFeed.m
//  Days
//
//  Created by Dan Waller on 8/12/13.
//
//

#import "loadFeed.h"
#import "Parser.h"
#import "Detail.h"


@implementation loadFeed

@synthesize items;


- (NSDictionary *)loadData:(NSString *)url {
    
    Parser *rssParser = [[Parser alloc] init];
    [rssParser parseRssFeed:url withDelegate:self];
    
    NSLog(@"Items: %@",items);
    return items;
}




@end
