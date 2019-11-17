//
//  AddCellViewController.swift
//  TaskTable
//
//  Created by Лада on 15/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

class AddCellViewController: UIViewController {
    
    var delegate: AddTask!

    let textLabel: UITextView = {
        let textLabel = UITextView()
        textLabel.text = ""
        textLabel.backgroundColor = .white
        textLabel.alpha = 0.5
        return textLabel
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let needSize = self.view.bounds
        view.frame = CGRect(x: needSize.width/3, y: needSize.height/3, width: needSize.width/3, height: needSize.height/3)
        navigationItem.title = "Task table"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        textLabel.frame = CGRect(x: view.frame.width/30, y: view.frame.width/6, width: view.frame.width/1.075, height: view.frame.width/1.25)
        
        view.addSubview(textLabel)

    }
    
    @objc func closeButton() {
        navigationController?.view.removeFromSuperview()
    }

    @objc func addTask() {
        delegate.AddTask(cellText: textLabel.text)
        navigationController?.view.removeFromSuperview()
    }
}
