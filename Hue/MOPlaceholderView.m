//
//  MOPlaceholderView.m
//  Hue
//
//  Created by Mike Onorato on 4/28/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOPlaceholderView.h"

@implementation MOPlaceholderView

- (id)init {
  self = [super init];
  if ( self ) {
    self.backgroundColor = [MOStyles blueLightBackground];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = self.backgroundColor;
    _titleLabel.textColor = [MOStyles grayMediumText];
    _titleLabel.font = [UIFont boldSystemFontOfSize: 20.0f];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.shadowColor = [UIColor colorWithWhite: 1.0f alpha: 0.7f];
    _titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [self addSubview: _titleLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.backgroundColor = self.backgroundColor;
    _messageLabel.textColor = [MOStyles grayMediumText];
    _messageLabel.font = [UIFont systemFontOfSize: 16.0f];
    _messageLabel.textAlignment = UITextAlignmentCenter;
    _messageLabel.shadowColor = [UIColor colorWithWhite: 1.0f alpha: 0.7f];
    _messageLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _messageLabel.numberOfLines = 2;
    [self addSubview: _messageLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  float yPadding = 15.0f;
  float titleTopPadding = iPad ? 200.0f: iPhone4Inch ? 150.0f : 115.0f;
  float titleHeight = 40.0f;
  float messageTopPadding = 0.0f;
  float messageHeight = 60.0f;
  
  _titleLabel.frame = CGRectMake(yPadding,
                                 titleTopPadding,
                                 self.frame.size.width - 2 * yPadding,
                                 titleHeight);
  _messageLabel.frame = CGRectMake(yPadding,
                                   titleTopPadding + titleHeight + messageTopPadding,
                                   self.frame.size.width - 2 * yPadding,
                                   messageHeight);
}

@end
