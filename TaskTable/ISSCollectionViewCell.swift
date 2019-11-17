//
//  ISSCollectionViewCell.swift
//  TaskTable
//
//  Created by Лада on 09/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

class ISSCollectionViewCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        textLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
}
