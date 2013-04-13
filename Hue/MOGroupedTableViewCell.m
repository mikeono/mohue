//
//  MOGroupedTableViewCell.m
//  Hue
//
//  Created by Mike Onorato on 4/12/13.
//  Copyright (c) 2013 Mike Onorato. All rights reserved.
//

#import "MOGroupedTableViewCell.h"

@implementation MOGroupedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
  if ( self ) {
    // Initialization code
  }
  return self;
}

- (CGSize)outerPadding {
  return CGSizeMake(self.contentView.frame.origin.x - 1.0f, 0.0f);
}

@end
