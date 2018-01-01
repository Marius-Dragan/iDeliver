//
//  DropDownBtn.swift
//  iDeliver
//
//  Created by Marius Dragan on 01/01/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import UIKit

protocol dropDownDelegate {
    func dropDownWasPressed(string: String)
}

class DropDownBtn: UIButton, dropDownDelegate {
    
    var dropDownSortView = DropDownView()
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
        
        dropDownSortView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        dropDownSortView.delegate = self
        dropDownSortView.translatesAutoresizingMaskIntoConstraints = false
    }
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropDownSortView)
        self.superview?.bringSubview(toFront: dropDownSortView)
        dropDownSortView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropDownSortView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropDownSortView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropDownSortView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func dropDownWasPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDownSortView()
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            if self.dropDownSortView.tableView.contentSize.height > 150 {
                  self.height.constant = 150
            } else {
                self.height.constant = self.dropDownSortView.tableView.contentSize.height
            }
          
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.dropDownSortView.layoutIfNeeded()
                self.dropDownSortView.center.y +=  self.dropDownSortView.frame.height / 2
            }, completion: nil)
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                 self.dropDownSortView.center.y -=  self.dropDownSortView.frame.height / 2
                self.dropDownSortView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dismissDropDownSortView() {
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.dropDownSortView.center.y -=  self.dropDownSortView.frame.height / 2
            self.dropDownSortView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownSortOptions = [String]()
    var tableView = UITableView()
    
    var delegate: dropDownDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.darkGray
        self.backgroundColor = UIColor.darkGray
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownSortOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownSortOptions[indexPath.row]
        cell.backgroundColor = UIColor.darkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownWasPressed(string: dropDownSortOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        print(dropDownSortOptions[indexPath.row])
    }
}




