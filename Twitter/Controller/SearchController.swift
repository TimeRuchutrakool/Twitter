//
//  ExploreController.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 4/26/23.
//

import UIKit

private let reuseidentifier = "UserCell"

enum SearchControllerConfiguration{
    case messages
    case userSearch
}

class SearchController: UITableViewController{
    
    //MARK: - Properties
    
    private let config: SearchControllerConfiguration
    
    private var users = [User](){
        didSet{
            tableView.reloadData()
        }
    }
    
    private var filteredUsers = [User](){
        didSet{
            tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Life Cycle
    init(config: SearchControllerConfiguration) {
        self.config = config
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Functions
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = config == .messages ? "NewMessage" : "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseidentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        if config == .messages{
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        }
    }
    
    @objc func handleCancel(){
        dismiss(animated: true)
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func fetchUsers(){
        UserService.shared.fetchUseers { users in
            self.users = users
        }
    }
    
}

extension SearchController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier,for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        filteredUsers = users.filter({ $0.username.contains(searchText) || $0.fullname.contains(searchText)})
    }
    
    
}
