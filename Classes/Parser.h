//
//  Parser.h
//  Days
//
//  Created by dawaller on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

 @protocol ParserDelegate <NSObject>  
 - (void)receivedItems:(NSArray *)theItems;  
 @end  
   
 @interface Parser : NSObject <NSXMLParserDelegate> {  
     id _delegate;  
       
     NSMutableData *responseData;  
     NSMutableArray *items;  
       
     NSMutableDictionary *item;  
	@private
     NSString *currentElement;  
     NSMutableString * currentTitle, * currentDate, * currentSummary, * currentPodcastLink;  
 }  

@property (strong, nonatomic) NSString *currentElement;
 @property (strong, nonatomic) NSMutableData *responseData;  
 @property (strong, nonatomic) NSMutableArray *items;  
 //@property (retain, nonatomic) NSMutableString *currentTitle;  
 //@property (retain, nonatomic) NSMutableString *currentDate;  
 //@property (retain, nonatomic) NSMutableString *currentSummary;  
 //@property (retain, nonatomic) NSMutableString *currentPodcastLink;  
   
 - (void)parseRssFeed:(NSString *)url withDelegate:(id)aDelegate;  
   
 - (id)delegate;  
 - (void)setDelegate:(id)new_delegate;  
   
 @end  