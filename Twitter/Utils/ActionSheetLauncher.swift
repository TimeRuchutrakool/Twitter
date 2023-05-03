//
//  ActionSheetLauncher.swift
//  Twitter
//
//  Created by Time Ruchutrakool on 5/2/23.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"

protocol ActionSheetLauncherDelegate: AnyObject{
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject{
    
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    
    private lazy var vm = ActionSheetViewModel(user: user)
    
    weak var delegate: ActionSheetLauncherDelegate?
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
       let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: UIView = {
       let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 12,paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50/2
  
        return view
    }()
    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }
    
    func show(){
        
        guard let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last else {return}
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat(vm.options.count*60) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            //self.tableView.frame.origin.y -= height
            self.showTableView(true)
        }
    }
    
    func showTableView(_ shouldShow:Bool){
        guard let window = window else {return}
        guard let height = tableViewHeight else {return}
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
    
}

extension ActionSheetLauncher: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = vm.options[indexPath.row]
        return cell
    }
}

extension ActionSheetLauncher: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = vm.options[indexPath.row]
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: { _ in
            self.delegate?.didSelect(option: option)
        }

        
        delegate?.didSelect(option: option)
    }
}
