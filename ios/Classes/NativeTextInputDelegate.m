#import "NativeTextInputDelegate.h"

@implementation NativeTextInputDelegate {
    FlutterMethodChannel* _channel;
    id _Nullable _args;
    CGRect _previousRect;
    int _currentLineIndex;
    NSTextAlignment _taTextAlign;
    NSTextAlignment _taPlaceholderTextAlign;
    double _textViewHeight;
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args paramTextAlign:(NSTextAlignment)taTextAlign paramPlaceholderTextAlign:(NSTextAlignment)taPlaceholderTextAlign paramTextViewHeight:(double)textViewHeight {
    self = [super init];
    if (self) {
        _channel = channel;
        _args = args;
        _previousRect = CGRectZero;
        _currentLineIndex = 0;
        _taTextAlign = taTextAlign;
        _taPlaceholderTextAlign = taPlaceholderTextAlign;
        _textViewHeight = textViewHeight;
    }
    return self;
}

- (void)resetLineIndex {
    _previousRect = CGRectZero;
    _currentLineIndex = 0;
}

-(UIColor *)colorfromString:(NSString *)colorname {
    SEL labelColor = NSSelectorFromString(colorname);
    UIColor *color = [UIColor performSelector:labelColor];
    return color;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:_args[@"placeholder"]]) {
        textView.text = @"";
        textView.textColor = [self colorfromString:_args[@"textColor"]];
        textView.textAlignment = _taTextAlign;
    }
    [_channel invokeMethod:@"inputStarted"
                 arguments:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextPosition *position = [textView endOfDocument];
    CGRect currentRect = [textView caretRectForPosition:position];
    
    // https://github.com/KennethTsang/GrowingTextView

    // if (_previousRect.origin.y == 0.0 ) { _previousRect = currentRect; }
    
    // [_channel invokeMethod:@"debug_msg" arguments:@{ @"numb": [NSNumber numberWithInt: _previousRect.origin.y] }];
    // [_channel invokeMethod:@"debug_msg" arguments:@{ @"numb": [NSNumber numberWithInt: currentRect.origin.y] }];

    if (abs(currentRect.origin.y - _previousRect.origin.y) > _textViewHeight) {
        // multi line change
        int lines = ((int)((abs(currentRect.origin.y - _previousRect.origin.y) / _textViewHeight) + 0.5)) + 1;
        // [_channel invokeMethod:@"debug_msg" arguments:@{ @"numb": [NSNumber numberWithInt: lines] }];

        if (currentRect.origin.y > _previousRect.origin.y) {
            _currentLineIndex += lines;
        } else if (currentRect.origin.y < _previousRect.origin.y) {
            _currentLineIndex -= lines;
        }
    } else {
        // single line change
        if (currentRect.origin.y > _previousRect.origin.y) {
            _currentLineIndex += 1;
        } else if (currentRect.origin.y < _previousRect.origin.y) {
            _currentLineIndex -= 1;
        }
    }

    if (_currentLineIndex < 1) {
        _currentLineIndex = 1;
    }
    
    _previousRect = currentRect;
    
    if (textView.text == 0) {
        textView.textColor = [self colorfromString:_args[@"placeholderTextColor"]];
    } else {
        textView.textColor = [self colorfromString:_args[@"textColor"]];
    }
    
    [_channel invokeMethod:@"inputValueChanged" arguments:@{ @"text": textView.text, @"currentLine": [NSNumber numberWithInt: _currentLineIndex], @"height": [NSNumber numberWithInt: currentRect.origin.y], @"defaultHeight": [NSNumber numberWithDouble: _textViewHeight] }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = _args[@"placeholder"];
        textView.textColor = [self colorfromString:_args[@"placeholderTextColor"]];
        textView.textAlignment = _taPlaceholderTextAlign;
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
