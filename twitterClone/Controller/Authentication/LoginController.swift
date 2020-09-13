//
//  File.swift
//  twitterClone
//
//  Created by joao camargo on 31/08/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - properties
    private let logoImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
//    private lazy var emailContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .red
//        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        let iv = UIImageView()
//        iv.image = #imageLiteral(resourceName: "mail")
//        view.addSubview(iv)
//        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingRight: 8)
//        iv.setDimensions(width: 24, height: 24)
//
//        return view
//    }()

    
    private let emailTextField: UITextField = {
        return Utilities().textField(withPlaceHolder: "Email")
    }()
    
    private let passwordTextField: UITextField = {
        var tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton : UIButton = {
        let button = Utilities().attributedButton("Don't have an account?", " Sign Up")
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)

        return button
    }()
    

    
    private lazy var emailContainerView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"),textField: emailTextField)
    private lazy var passwordContainerView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),textField: passwordTextField)
    
    /*private lazy var passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingRight: 8)
        iv.setDimensions(width: 24, height: 24)
        
        return view
    }()*/
    
    //MARK: - Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - selector
      @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("ERROR LOGIN IN \(error.localizedDescription)")
                return
            }
            
            guard let window =  UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
      }
      
      @objc func handleShowSignUp(){
          let controller = RegistrationController()
          navigationController?.pushViewController(controller, animated: true)
      }
      
      //MARK: - Helpers
    
    func configureUI()
    {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
        
      
        
    }
    
}
