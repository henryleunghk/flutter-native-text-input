#import "NativeTextInputPlugin.h"
#import "NativeTextInputFactory.h"

@implementation NativeTextInputPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NativeTextInputFactory* textFieldFactory =
        [[NativeTextInputFactory alloc] initWithMessenger:registrar.messenger];
    
    [registrar registerViewFactory:textFieldFactory
                            withId:@"flutter_native_text_input"];
}

@end
