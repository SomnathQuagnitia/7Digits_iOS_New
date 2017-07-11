

#import "MessageData.h"

@implementation MessageData


- (NSMutableDictionary *)createdDictionaryForMsgId:(NSString *)msgId text:(NSString *)text date:(NSDate *)date msgType:(NSInteger)msgType imageData:(NSString *)imageData attachment:(NSData *)attachment videoURL:(NSString *)videoURL mediaType:(NSInteger)medType imageurl:(NSString *)imageurl download:(NSString *)download
{
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    [messageDict setValue:msgId forKey:@"SenderUserId"];
    [messageDict setValue:text forKey:@"msg"];
    [messageDict setValue:date forKey:@"date"];
    [messageDict setValue:imageData forKey:@"image"];
    [messageDict setValue:download forKey:@"download"];
     [messageDict setValue:imageurl forKey:@"ChatMessageId"];
    if (attachment != nil)
    {
        [messageDict setValue:attachment forKey:@"attachment"];
        [messageDict setValue:videoURL forKey:@"videoURL"];
    }
    [messageDict setValue:[NSString stringWithFormat:@"%ld",(long)msgType]forKey:@"msgType"];
    [messageDict setValue:[NSString stringWithFormat:@"%ld",(long)medType]forKey:@"medType"];
    
    return messageDict;
}
- (instancetype)initWithMsgId:(NSString *)msgId text:(NSString *)text date:(NSDate *)date msgType:(NSInteger)msgType mediaType:(NSInteger)medType img:(NSString *)img attachment:(NSData *)attachment videoURL:(NSString *)videoURL{
    self = [super init];
    if (self) {
        _msgId = msgId;
        _text = text;
        _date = date;
        _messageType = msgType;
        _mediaType = medType;
        _img = img;
        _attachment = attachment;
        _videoURL = videoURL;
    }
    return self;
}
@end
