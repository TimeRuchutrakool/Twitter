//
//  EditProfileViewModel.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/4/23.
//

import Foundation

enum EditProfileOptions: Int,CaseIterable{
    
    case fullname
    case username
    case bio
    
    var desc: String{
        switch self {
        case .fullname:
            return "Name"
        case .username:
            return "Username"
        case .bio:
           return "Bio"
        }
    }
}

struct EditProfileViewModel{
    
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String{
        return option.desc
    }
    
    var optionValue: String?{
        switch option {
            
        case .fullname:
            return user.fullname
        case .username:
            return user.username
        case .bio:
            return user.bio
        }
    }
    
    var shouldHideTextField: Bool{
        return option == .bio
    }
    
    var shouldHideTextView: Bool{
        return option != .bio
    }
    
    var profileImage: URL{
        return user.profileImageURL
    }
    
    var shouldHidePlaceHolderLabel: Bool{
        return user.bio != nil
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
    
}
