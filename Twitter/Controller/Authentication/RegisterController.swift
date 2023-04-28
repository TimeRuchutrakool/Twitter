//
//  RegisterController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit
import Firebase

class RegisterController: UIViewController{
    
    //MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView:UIView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_mail_outline_white_2x-1"), textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView:UIView = {
        let view = Utilities().inputContainerView(withImage:UIImage(named: "ic_lock_outline_white_2x"), textField: passwordTextField)
        return view
    }()
    
    private lazy var fullNameContainerView:UIView = {
        let view = Utilities().inputContainerView(withImage:UIImage(named: "ic_person_outline_white_2x"), textField: fullNameTextField)
        return view
    }()
    
    private lazy var userNameContainerView:UIView = {
        let view = Utilities().inputContainerView(withImage:UIImage(named: "ic_person_outline_white_2x"), textField: userNameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceHolder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceHolder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceHolder: "Full Name")
        return textField
    }()
    
    private let userNameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceHolder: "Username")
        return textField
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an Account? ", "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    //MARK: - Selectors
    
    //MARK: - Functions
    func layout(){
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view,topAnchor: view.safeAreaLayoutGuide.topAnchor,paddingTop: 50)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,passwordContainerView,fullNameContainerView,userNameContainerView,signUpButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 32,paddingRight: 32)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 40,paddingRight: 40)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddProfilePhoto(){
        present(imagePicker, animated: true)
    }
    
    @objc func handleSignUp(){
        guard let profileImage = profileImage else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username = userNameTextField.text?.lowercased() else {return}
        
        let credentials = AuthCredential(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        AuthService.shared.registerUser(credentials: credentials){ error,ref in
            guard let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last else {return}
            guard let tab = window.rootViewController as? MainTabController else {return}
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true)
        }
       
    }
    
}

extension RegisterController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        plusPhotoButton.layer.cornerRadius = 150/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleToFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3

        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
}
