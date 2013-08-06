//
//  DayParse.h
//  Days
//
//  Created by dawaller on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ParserDelegate <NSObject>  
- (void)receivedItems:(NSArray *)theItems;  
@end  

@interface DayParse : NSObject <NSXMLParserDelegate>  {
	
	id _delegate;  
	
	NSMutableData *responseData;  
	NSMutableArray *items;  
	
	NSMutableDictionary *item;  
	NSString *currentElement;  
	NSMutableString * currentTitle, * currentSummary, *index; 
	
}  

@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) NSMutableData *responseData;  
@property (strong, nonatomic) NSMutableArray *items;  
//@property (retain, nonatomic) NSMutableString *currentTitle;  
//@property (retain, nonatomic) NSMutableString *currentSummary;  
//@property (retain, nonatomic) NSMutableString *index;

 
- (void) parse:(NSURL *)url withDelegate:(id)aDelegate;
- (id)delegate;  
- (void)setDelegate:(id)new_delegate;  


@end