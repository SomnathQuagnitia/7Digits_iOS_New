

#import <Foundation/Foundation.h>

@interface MessageData : NSObject

@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, assign) NSInteger mediaType;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSData *attachment;
@property (nonatomic, assign) NSString *videoURL;

- (instancetype)initWithMsgId:(NSString *)msgId text:(NSString *)text date:(NSDate *)date msgType:(NSInteger)msgType mediaType:(NSInteger)medType img:(NSString *)img attachment:(NSData *)attachment videoURL:(NSString *)videoURL;

- (NSMutableDictionary *)createdDictionaryForMsgId:(NSString *)msgId text:(NSString *)text date:(NSDate *)date msgType:(NSInteger)msgType imageData:(NSString *)imageData attachment:(NSData *)attachment videoURL:(NSString *)videoURL mediaType:(NSInteger)medType imageurl:(NSString *)imageurl download:(NSString *)download;

//- (NSMutableDictionary *)createdDictionaryForMsgId:(NSString *)msgId text:(NSString *)text date:(NSDate *)date msgType:(NSInteger)msgType imageData:(NSData *)imageData;
@end
