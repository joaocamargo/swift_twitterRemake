//
//  File.swift
//  twitterClone
//
//  Created by joao camargo on 16/10/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit


class ActionSheetCell: UITableViewCell {
    
    //MARK: - properties
    
    var option: ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    
    private let optionImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Text Option"
        return label
    }()
    
    //MARK: - lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier reuseIdentidier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentidier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: leftAnchor, paddingLeft: 8)
        optionImageView.setDimensions(width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - helpers
    
    func configure(){
        titleLabel.text = option?.description
    }
    
    
}