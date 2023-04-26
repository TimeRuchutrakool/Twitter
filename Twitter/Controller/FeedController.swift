//
//  FeedController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit

class FeedController: UIViewController{
    
    //MARK: - Properties
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
       
    }
    
    //MARK: - Functions
    
    func configureUI(){
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
}
