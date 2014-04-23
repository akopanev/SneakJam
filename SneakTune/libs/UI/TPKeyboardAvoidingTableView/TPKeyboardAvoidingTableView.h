//
//  TPKeyboardAvoidingTableView.h
//
//  Created by Michael Tyson on 11/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

// added by ako on Dec 12, 2012, 22:53, in a train number 26 Moscow - Izhevsk
// original class is useless sometimes, because classes like textfields might not be subview
//
@class TPKeyboardAvoidingTableView;
@protocol TPKeyboardAvoidingTableViewDelegate <NSObject>
@optional
- (UIView *)viewToSearchForFirstResponder:(TPKeyboardAvoidingTableView *)tableView;
@end

@interface TPKeyboardAvoidingTableView : UITableView {
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
	
	id <TPKeyboardAvoidingTableViewDelegate>__avoidingDelegate;
}
@property (nonatomic, assign) id <TPKeyboardAvoidingTableViewDelegate>avoidingDelegate;
@property (nonatomic, assign) BOOL  ignoreKeyboardEvents;//default NO.//added by fs87
@property (nonatomic, readonly) BOOL            keyboardVisible;
- (void)adjustOffsetToIdealIfNeeded;
- (UIView*)findFirstResponderBeneathView:(UIView*)view;

- (UIEdgeInsets)contentInsetForKeyboard;
- (CGRect)keyboardRect;
@end
