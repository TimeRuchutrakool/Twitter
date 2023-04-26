//
//  LoginController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit

class LoginController: UIViewController{
    
    //MARK: - Properties
    private let logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "TwitterLogo")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
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
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view,topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 200, height: 200)
    }
}
