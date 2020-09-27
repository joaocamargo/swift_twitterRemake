//
//  ProfileHeader.swift
//  twitterClone
//
//  Created by joao camargo on 27/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

class ProfileHeader: UICollectionReusableView {
    
    
    //MARK: - Properties
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
