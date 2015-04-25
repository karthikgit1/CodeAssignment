//
//  MyCustomCell.m
//  Coding_Assignment
//
//  Created by Vy Systems - iOS1 on 4/21/15.
//  Copyright (c) 2015 Vy Systems - iOS1. All rights reserved.
//

#import "MyCustomCell.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation MyCustomCell
{
    

}
@synthesize lblTitle,lblDescription,imgvw;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:lblTitle];
                
        
        //*********IMAGEVIEW********
        
        imgvw = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        imgvw.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [self.contentView addSubview:imgvw];
        
        //*************DESCRIPTION LABEL****************//
        lblDescription = [[UILabel alloc] initWithFrame:CGRectZero];
        lblDescription.font = [UIFont fontWithName:@"Arial" size:13.0f];
        lblDescription.translatesAutoresizingMaskIntoConstraints = NO;
        
        lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        lblDescription.numberOfLines = 0;
        
        [self.contentView addSubview:lblDescription];
        
        
        NSLayoutConstraint *constraint;
        
        //***************LBLTITLE***************
        
        //*******Leading Space Constraints *************
        constraint = [NSLayoutConstraint constraintWithItem:lblTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:15.0f];
        
        [self.contentView addConstraint:constraint];
        
        //**************Top Space Constraints**********
        constraint = [NSLayoutConstraint constraintWithItem:lblTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:10.f];
        
        [self.contentView addConstraint:constraint];
        
        
        //****************Bottom Space Constraints**********
        constraint = [NSLayoutConstraint constraintWithItem:lblTitle attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20.f];
        
        [self.contentView addConstraint:constraint];
        
        //********IMGVW CONSTRAINTS********
        
        //*********HEIGHT CONSTRAINTS******
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imgvw
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:80.0]];
        
        //*************WIDTH CONSTRAINTS*******//
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:imgvw
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:80.0]];
        
       
        
        //************Trailing Space Constraints**************
        constraint = [NSLayoutConstraint constraintWithItem:imgvw attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-10.f];
        
        [self.contentView addConstraint:constraint];
        
        
        //**************Top Space Constraints**********
        constraint = [NSLayoutConstraint constraintWithItem:imgvw attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:20.f];
        
        [self.contentView addConstraint:constraint];
        
        
        //****************Bottom Space Constraints**********
        constraint = [NSLayoutConstraint constraintWithItem:imgvw attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20.f];
        
        [self.contentView addConstraint:constraint];
        
        
        
        //****************DESCRIPTION LABEL************//
        
        //*******Leading Space Constraints *************
        constraint = [NSLayoutConstraint constraintWithItem:lblDescription attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10.0f];
        
        [self.contentView addConstraint:constraint];
        
        //************Trailing Space Constraints**************
        constraint = [NSLayoutConstraint constraintWithItem:lblDescription attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-100.f];
        
        [self.contentView addConstraint:constraint];
        
        
        //**************Top Space Constraints**********
        constraint = [NSLayoutConstraint constraintWithItem:lblDescription attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lblTitle attribute:NSLayoutAttributeTop multiplier:1.0f constant:30.f];
        
        [self.contentView addConstraint:constraint];
        
        
        //****************Bottom Space Constraints**********
        constraint = [NSLayoutConstraint constraintWithItem:lblDescription attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:10.f];
        
        [self.contentView addConstraint:constraint];
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
