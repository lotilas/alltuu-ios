//
//  PropertyLikeCountView.swift
//  
//
//  Created by MAC on 15/9/25.
//
//

import UIKit

class PropertyLikeCountButton: PropertyButton {
    init(labelText:String){
        super.init(labelText:labelText, iconFont:"\u{e620}")
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
