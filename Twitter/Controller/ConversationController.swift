//
//  ConversationController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit

class ConversationController: UIViewController{
    
    //MARK: - Properties
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
       
    }
    
    //MARK: - Functions
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
    
}
