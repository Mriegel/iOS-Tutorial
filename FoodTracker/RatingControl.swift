//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Michael Riegelhaupt on 5/3/16.
//  Copyright © 2016 Riegelhaupt. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    let BUTTON_WIDTH = 44;
    let BUTTON_PADDING = 5;
    let STAR_COUNT = 5;
    
    var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        for _ in 0..<STAR_COUNT {
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected]) //this is a highlighted AND selected state
            //remove additiional highlight when selecting.
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
            
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize * STAR_COUNT) + (BUTTON_PADDING * (STAR_COUNT - 1));
        return CGSize(width: width, height: buttonSize)
    }
    
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = getFloatOffset(index, buttonSize: buttonSize)
            button.frame = buttonFrame
        }
        updateRenderingForRating()
    }
    
    func ratingButtonTapped(button: UIButton) {
        rating = ratingButtons.indexOf(button)! + 1 //force unwrap the optional indexOf call.
        updateRenderingForRating()
        
    }
    
    func getFloatOffset(index: Int, buttonSize: Int) -> CGFloat {
        return CGFloat(index * (buttonSize + BUTTON_PADDING));
    }
    
    func updateRenderingForRating() {
        for (index, button) in ratingButtons.enumerate() {
            button.selected = index < rating;
        }
    }

}
