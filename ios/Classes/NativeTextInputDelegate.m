#import "NativeTextInputDelegate.h"

@implementation NativeTextInputDelegate {
    FlutterMethodChannel* _channel;
    id _Nullable _args;
    
    float _fontSize;
    UIColor* _fontColor;
    
    float _placeholderFontSize;
    UIColor* _placeholderFontColor;
    
    CGRect _previousRect;
    int _currentLineIndex;
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args {
    self = [super init];
    
    _fontSize = 16.0;
    _fontColor = UIColor.blackColor;
    
    _placeholderFontSize = 16.0;
    _placeholderFontColor = UIColor.lightGrayColor;
    
    if (args[@"fontSize"] && ![args[@"fontSize"] isKindOfClass:[NSNull class]]) {
        NSNumber* fontSize = args[@"fontSize"];
        _fontSize = [fontSize floatValue];
        _placeholderFontSize = _fontSize;
    }
    if (args[@"fontColor"] && ![args[@"fontColor"] isKindOfClass:[NSNull class]]) {
        NSDictionary* fontColor = args[@"fontColor"];
        _fontColor = [UIColor colorWithRed:[fontColor[@"red"] floatValue]/255.0 green:[fontColor[@"green"] floatValue]/255.0 blue:[fontColor[@"blue"] floatValue]/255.0 alpha:[fontColor[@"alpha"] floatValue]/255.0];
    }
    if (args[@"placeholderFontSize"] && ![args[@"placeholderFontSize"] isKindOfClass:[NSNull class]]) {
        NSNumber* placeholderFontSize = args[@"placeholderFontSize"];
        _placeholderFontSize = [placeholderFontSize floatValue];
    }
    if (args[@"placeholderFontColor"] && ![args[@"placeholderFontColor"] isKindOfClass:[NSNull class]]) {
        NSDictionary* placeholderFontColor = args[@"placeholderFontColor"];
        _placeholderFontColor = [UIColor colorWithRed:[placeholderFontColor[@"red"] floatValue]/255.0 green:[placeholderFontColor[@"green"] floatValue]/255.0 blue:[placeholderFontColor[@"blue"] floatValue]/255.0 alpha:[placeholderFontColor[@"alpha"] floatValue]/255.0];
    }
    
    if (self) {
        _channel = channel;
        _args = args;
        _previousRect = CGRectZero;
        _currentLineIndex = 1;
    }
    return self;
}

- (float)fontSize {
    return _fontSize;
}
- (UIColor *)fontColor {
    return _fontColor;
}
- (float)placeholderFontSize {
    return _placeholderFontSize;
}
- (UIColor *)placeholderFontColor {
    return _placeholderFontColor;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:_args[@"placeholder"]]) {
        textView.text = @"";
        textView.textColor = _fontColor;
        textView.font = [UIFont systemFontOfSize:_fontSize];
    }
    [_channel invokeMethod:@"inputStarted"
                 arguments:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextPosition *position = [textView endOfDocument];
    CGRect currentRect = [textView caretRectForPosition:position];
    
    if (_previousRect.origin.y == 0.0 ) { _previousRect = currentRect; }
    
    if (currentRect.origin.y > _previousRect.origin.y) {
        _currentLineIndex += 1;
    } else if (currentRect.origin.y < _previousRect.origin.y) {
        _currentLineIndex -= 1;
    }
    
    _previousRect = currentRect;
    
    textView.textColor = textView.text == 0 ? _placeholderFontColor : _fontColor;
    textView.font = [UIFont systemFontOfSize:textView.text == 0 ? _placeholderFontSize : _fontSize];
    
    [_channel invokeMethod:@"inputValueChanged" arguments:@{ @"text": textView.text, @"currentLine": [NSNumber numberWithInt: _currentLineIndex] }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = _args[@"placeholder"];
        textView.textColor = _placeholderFontColor;
        textView.font = [UIFont systemFontOfSize:_placeholderFontSize];
    }
    [_channel invokeMethod:@"inputFinished"
                 arguments:@{ @"text": textView.text }];
}

 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
     if (
         textView.textContainer.maximumNumberOfLines == 1 &&
         [text isEqualToString:@"\n"]
     ) {
         [textView resignFirstResponder];
         return false;
     } else if (textView.textContainer.maximumNumberOfLines == 0) {
         return true;
     } else {
         NSUInteger existingLines = [textView.text componentsSeparatedByString:@"\n"].count;
         NSUInteger newLines = [text componentsSeparatedByString:@"\n"].count;
         NSUInteger linesAfterChange = existingLines + newLines - 1;
         return linesAfterChange <= textView.textContainer.maximumNumberOfLines;
     }
 }

@end
