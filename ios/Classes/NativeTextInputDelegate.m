#import "NativeTextInputDelegate.h"

@implementation NativeTextInputDelegate {
    FlutterMethodChannel* _channel;
    id _Nullable _args;
    
    float _fontSize;
    UIFontWeight _fontWeight;
    UIColor* _fontColor;
    
    float _placeholderFontSize;
    UIFontWeight _placeholderFontWeight;
    UIColor* _placeholderFontColor;
    
    CGRect _previousRect;
    int _currentLineIndex;
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel arguments:(id _Nullable)args {
    self = [super init];
    
    _fontSize = 16.0;
    _fontWeight = UIFontWeightRegular;
    _fontColor = UIColor.blackColor;
    
    _placeholderFontSize = 16.0;
    _placeholderFontWeight = UIFontWeightRegular;
    _placeholderFontColor = UIColor.lightGrayColor;
    
    if (args[@"fontSize"] && ![args[@"fontSize"] isKindOfClass:[NSNull class]]) {
        NSNumber* fontSize = args[@"fontSize"];
        _fontSize = [fontSize floatValue];
        _placeholderFontSize = _fontSize;
    }
    if (args[@"fontWeight"] && ![args[@"fontWeight"] isKindOfClass:[NSNull class]]) {
        _fontWeight = [self fontWeightFromString:args[@"fontWeight"]];
    }
    if (args[@"fontColor"] && ![args[@"fontColor"] isKindOfClass:[NSNull class]]) {
        NSDictionary* fontColor = args[@"fontColor"];
        _fontColor = [UIColor colorWithRed:[fontColor[@"red"] floatValue]/255.0 green:[fontColor[@"green"] floatValue]/255.0 blue:[fontColor[@"blue"] floatValue]/255.0 alpha:[fontColor[@"alpha"] floatValue]/255.0];
    }
    if (args[@"placeholderFontSize"] && ![args[@"placeholderFontSize"] isKindOfClass:[NSNull class]]) {
        NSNumber* placeholderFontSize = args[@"placeholderFontSize"];
        _placeholderFontSize = [placeholderFontSize floatValue];
    }
    if (args[@"placeholderFontWeight"] && ![args[@"placeholderFontWeight"] isKindOfClass:[NSNull class]]) {
        _placeholderFontWeight = [self fontWeightFromString:args[@"placeholderFontWeight"]];
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

- (UIColor *)fontColor {
    return _fontColor;
}

- (UIFont *)font {
    return [UIFont systemFontOfSize:_fontSize weight:_fontWeight];
}

- (UIColor *)placeholderFontColor {
    return _placeholderFontColor;
}

- (UIFont *)placeholderFont {
    return [UIFont systemFontOfSize:_placeholderFontSize weight:_placeholderFontWeight];
}

- (UIFontWeight)fontWeightFromString:(NSString*)fontWeight {
    if (!fontWeight || [fontWeight isKindOfClass:[NSNull class]]) {
        return UIFontWeightRegular;
    }
    if ([fontWeight isEqualToString:@"FontWeight.w100"]) {
        return UIFontWeightUltraLight;
    } else if ([fontWeight isEqualToString:@"FontWeight.w200"]) {
        return UIFontWeightThin;
    } else if ([fontWeight isEqualToString:@"FontWeight.w300"]) {
        return UIFontWeightLight;
    } else if ([fontWeight isEqualToString:@"FontWeight.w400"]) {
        return UIFontWeightRegular;
    } else if ([fontWeight isEqualToString:@"FontWeight.w500"]) {
        return UIFontWeightMedium;
    } else if ([fontWeight isEqualToString:@"FontWeight.w600"]) {
        return UIFontWeightSemibold;
    } else if ([fontWeight isEqualToString:@"FontWeight.w700"]) {
        return UIFontWeightBold;
    } else if ([fontWeight isEqualToString:@"FontWeight.w800"]) {
        return UIFontWeightHeavy;
    } else if ([fontWeight isEqualToString:@"FontWeight.w900"]) {
        return UIFontWeightBlack;
    }

    return UIFontWeightRegular;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:_args[@"placeholder"]]) {
        textView.text = @"";
        textView.textColor = _fontColor;
        textView.font = self.font;
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
    textView.font = textView.text == 0 ? self.placeholderFont : self.font;
    
    [_channel invokeMethod:@"inputValueChanged" arguments:@{ @"text": textView.text, @"currentLine": [NSNumber numberWithInt: _currentLineIndex] }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = _args[@"placeholder"];
        textView.textColor = _placeholderFontColor;
        textView.font = self.placeholderFont;
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
