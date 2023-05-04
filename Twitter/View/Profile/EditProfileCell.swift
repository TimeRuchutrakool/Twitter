//
//  EditProfileCell.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/4/23.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject{
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UICollectionViewCell{
    
    weak var delegate: EditProfileCellDelegate?
    
    var viewModel: EditProfileViewModel? {
        didSet{
            configure()
        }
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()
    
     lazy var infoTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        
        return textField
    }()
    
     lazy var bioTextView: InputTextView = {
       let tv = InputTextView()
        tv.font = .systemFont(ofSize: 14)
        tv.textColor = .twitterBlue
        tv.placeholder.text = "Bio"
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 16)
        
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor,left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 16,paddingRight: 8)
        
        addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor,left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 16,paddingRight: 8)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpdateUserInfo(){
        delegate?.updateUserInfo(self)
    }
    
    func configure(){
        guard let viewModel = viewModel else {return}
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
        bioTextView.placeholder.isHidden = viewModel.shouldHidePlaceHolderLabel
        bioTextView.text = viewModel.optionValue
    }
}
