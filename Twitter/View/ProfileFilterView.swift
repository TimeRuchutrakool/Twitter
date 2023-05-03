//
//  ProfileFilterView.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/28/23.
//

import UIKit

private let reuseableidentifier = "ProfileFilterCell"

protocol ProfileFilterViewDelegate: AnyObject{
    func filterView(_ view: ProfileFilterView,didSelect index:Int)
}

class ProfileFilterView: UIView{
    
    //MARK: -  Properties
    
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private let underlineView: UIView = {
       let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseableidentifier)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
    }
    
    override func layoutSubviews() {
        addSubview(underlineView)
        //if put this in init frame will be zero
        underlineView.anchor(left: leftAnchor,bottom: bottomAnchor,width: frame.width/3,height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ProfileFilterView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableidentifier, for: indexPath) as! ProfileFilterCell
        let options = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = options
        return cell
    }
}

extension ProfileFilterView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)

        let xPosition = cell?.frame.origin.x ?? 0
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
        
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}


extension ProfileFilterView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

