//
//  File.swift
//  twitterClone
//
//  Created by joao camargo on 31/08/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - properties
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - selector
      
      
      //MARK: - Helpers
    
    func configureUI()
    {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .twitterBlue
    }
    
}
