#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeTextInputDelegate : NSObject <UITextViewDelegate>

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args paramTextAlign:(NSTextAlignment)taTextAlign paramPlaceholderTextAlign:(NSTextAlignment)taPlaceholderTextAlign;
- (void)resetLineIndex;

@end

NS_ASSUME_NONNULL_END
