//
//  CaptionTextView.swift
//  twitterClone
//
//  Created by joao camargo on 12/09/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import Foundation
import UIKit

class CaptionTextView: UITextView {
    let placeholder: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame:frame,textContainer: textContainer)
        addSubview(placeholder)
        placeholder.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTextInputChange(){
        print("hide and show placeholder")
        placeholder.isHidden = !text.isEmpty
        //captionTextView.text = ""
    }
    
}