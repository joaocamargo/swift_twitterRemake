//
//  File.swift
//  twitterClone
//
//  Created by joao camargo on 31/08/20.
//  Copyright © 2020 joaocamargo. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class RegistrationController: UIViewController {
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    //MARK: - properties
    
    private let addProfilePhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        
        return btn
    }()
    
    private let emailTextField: UITextField = {
        return Utilities().textField(withPlaceHolder: "Email")
    }()
    
    private let passwordTextField: UITextField = {
        var tf = Utilities().textField(withPlaceHolder: "Password")
        tf.textContentType = .newPassword
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        return Utilities().textField(withPlaceHolder: "Full Name")
    }()
    
    private let usernameTextField: UITextField = {
        var tf = Utilities().textField(withPlaceHolder: "Username")
        return tf
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton : UIButton = {
        let button = Utilities().attributedButton("Do you have an account?", " Sign In")
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var emailContainerView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"),textField: emailTextField)
    private lazy var passwordContainerView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),textField: passwordTextField)
    private lazy var fullNameContainerView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"),textField: fullNameTextField)
    private lazy var usernameContainerView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"),textField: usernameTextField)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - selector
    @objc func handleAddProfilePhoto(){
        present(imagePicker, animated: true,completion: nil)
    }
    
    @objc func handleShowSignIn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegister(){
        print("registrar")
        guard let profileImage = profileImage else {
            return
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        
        let credentials = AuthCredentials(email: email, password: password, username: username, fullname: fullName, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials){(error, ref) in
            if let error = error {
                print("ERROR register IN \(error.localizedDescription)")
                return
            }
            guard let window =  UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Helpers
    
    func configureUI()
    {
        view.backgroundColor = .twitterBlue
        
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .twitterBlue
        view.addSubview(addProfilePhotoButton)
        addProfilePhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor,paddingTop: 20)
        addProfilePhotoButton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews:[emailContainerView,passwordContainerView,fullNameContainerView,usernameContainerView,registerButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: addProfilePhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingLeft: 16, paddingRight: 16)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        
        addProfilePhotoButton.layer.cornerRadius = 128/2
        addProfilePhotoButton.layer.masksToBounds = true
        addProfilePhotoButton.imageView?.contentMode = .scaleAspectFill
        addProfilePhotoButton.imageView?.clipsToBounds = true
        addProfilePhotoButton.layer.borderColor = UIColor.white.cgColor
        addProfilePhotoButton.layer.borderWidth = 3
        self.addProfilePhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
}
