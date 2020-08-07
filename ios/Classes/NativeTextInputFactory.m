#import "NativeTextInputFactory.h"
#import "NativeTextInput.h"

@implementation NativeTextInputFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    NativeInputField* textField = [[NativeInputField alloc] initWithFrame:frame
                                                     viewIdentifier:viewId
                                                          arguments:args
                                                    binaryMessenger:_messenger];
    return textField;
}

@end
