//
//  EditProfileController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/4/23.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject{
    func controller(_ controller:EditProfileController,wantsToUpdate user: User)
}

private let reuseIdentifier = "EditProfileCell"

class EditProfileController: UICollectionViewController{
    
    //MARK: - Properties
    
    weak var delegate: EditProfileControllerDelegate?
    
    private var user: User
    
    private lazy var headerView = EditProfileHeader()
    
    private let imagePicker = UIImagePickerController()
    private var selectedImage: UIImage? {
        didSet{
            headerView.profileImageView.image = selectedImage
        }
    }
    
    private var userInfoChange: Bool = false
    
    private var imageChanged: Bool{
        return selectedImage != nil
    }
    
    //MARK: - Life Cycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
        configureTableView()
        configureNavBar()
        
    }
    
    //MARK: - Selecter
    
    @objc func handleCancel(){
        dismiss(animated: true)
    }
    @objc func handleDone(){
        view.endEditing(true)
        guard imageChanged || userInfoChange else {return}
        updateUserData()
    }
    
    //MARK: - API
    
    func updateUserData(){
        if imageChanged && !userInfoChange{
            updateProfileImage()
        }
        if userInfoChange && !imageChanged{
            UserService.shared.saveUserData(user: user) { error, ref in
                
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        if userInfoChange && imageChanged{
            UserService.shared.saveUserData(user: user) { error, ref in
                self.updateProfileImage()
            }
        }
       
    }
    
    func updateProfileImage(){
        guard let image = selectedImage else {return}
        UserService.shared.updateProfileImage(image: image) { profileImageUrl in
            self.user.profileImageURL = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    //MARK: - Helpers
    func configureNavBar(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    func configureTableView(){
        collectionView.register(EditProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(EditProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        headerView.delegate = self
    }
    func configureImagePicker(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
   
    
    
}


extension EditProfileController{
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        cell.delegate = self
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return cell}
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! EditProfileHeader
        header.delegate = self
        header.user = user
        return header
    }
    
}

extension EditProfileController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return CGSize(width: 0, height: 0)}
        return option == .bio ? CGSize(width: view.frame.width, height: 100) : CGSize(width: view.frame.width, height: 48)
    }
}

extension EditProfileController: EditProfileHeaderDelegate{
    func didTappedChangeProfilePhoto() {
       present(imagePicker, animated: true)
    }
}

extension EditProfileController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        self.selectedImage = image
        dismiss(animated: true)
    }
}

extension EditProfileController: EditProfileCellDelegate{
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else {return}
        userInfoChange = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewModel.option{
        case .fullname:
            guard let fullname = cell.infoTextField.text else {return}
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else {return}
            user.username = username
        case .bio:
            user.bio = cell.bioTextView.text
        }
        
    }
}
