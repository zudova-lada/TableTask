//
//  ViewController.swift
//  TaskTable
//
//  Created by Лада on 07/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

protocol AddTask {
    func AddTask(cellText: String?)
    
}

final class ViewController: UIViewController, UICollectionViewDataSource, AddTask {
    func AddTask(cellText : String?) {
        let newRow = itemsArray[0].count
        let indexPath = IndexPath(row: itemsArray[0].count, section: 0)
        itemsArray[0].append("Task number \(newRow + 1)")
        
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }, completion: nil)
        
        let cell = collectionView.cellForItem(at: indexPath) as! ISSCollectionViewCell
        cell.textLabel.text = cellText
        self.cellText = cellText ?? ""
    }
    
   
    var itemsArray = [["To do"], ["In progress"],["In review"],["Done"]]

    var collectionView: UICollectionView!
    var screenSize: CGRect!
    let reuseIdentifier = "ISSCell"
    let sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var cellText = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Task table"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapButton))
        let layout = ISSCollectionViewFlowLayout()
        layout.sectionInset = sectionInset
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        
        screenSize = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
        collectionView.register(ISSCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = UIColor.black
        view.addSubview(collectionView)
    }
    
    
    @objc func tapButton() {
        let addCellViewController = AddCellViewController()
        addCellViewController.view.backgroundColor = .darkGray
        addCellViewController.delegate = self
        let navigationViewController = UINavigationController(rootViewController: addCellViewController)
        let minSize = min(self.view.bounds.width, self.view.bounds.height)
        navigationViewController.view.frame = CGRect(x: minSize/3, y: minSize/3, width: minSize/3, height: minSize/3)
        navigationController?.addChild(navigationViewController)
        navigationController?.view.addSubview(navigationViewController.view)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ISSCollectionViewCell
        cell.textLabel.text = itemsArray[indexPath.section][indexPath.row]
        if indexPath.row == 0 {
            cell.textLabel.backgroundColor = .gray
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemsArray.count
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            
            var dIndexPath = destinationIndexPath
            if dIndexPath.row > collectionView.numberOfItems(inSection: dIndexPath.section)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: dIndexPath.section) - 1
            }
            collectionView.performBatchUpdates({
                self.itemsArray[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                self.itemsArray[dIndexPath.section].insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            
            let cell = collectionView.cellForItem(at: dIndexPath) as! ISSCollectionViewCell
            cell.textLabel.text = cellText
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: screenSize.width/3, height: screenSize.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.itemsArray[indexPath.section][indexPath.row]
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        let cell = collectionView.cellForItem(at: indexPath) as! ISSCollectionViewCell
        cellText = cell.textLabel.text ?? ""
        
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView.hasActiveDrag
        {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let sourceIndexPaht = coordinator.items.first?.sourceIndexPath
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
            if (destinationIndexPath.row == 0)
            {
                destinationIndexPath.row = 1
            }
        }
        else
        {
            destinationIndexPath = IndexPath(row: sourceIndexPaht!.row, section: sourceIndexPaht!.section)
        }

        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }
}
