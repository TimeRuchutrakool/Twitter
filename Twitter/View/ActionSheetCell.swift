//
//  ActionSheetCell.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/2/23.
//

import UIKit

class ActionSheetCell: UITableViewCell{
    
    private let optionImageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "twitter_logo_blue")
        return image
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Option"
        return label
    }()
    
    var option: ActionSheetOptions?{
        didSet{
            configure()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: leftAnchor,paddingLeft: 8)
        optionImageView.setDimensions(width: 36, height: 36)
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor,paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        titleLabel.text = option?.desc
    }
    
}
