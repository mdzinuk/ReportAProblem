//
//  CustomViewController.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 6/10/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView1: UICollectionView! {
      didSet {
        collectionView1.allowsSelection = false
        }
    }
    @IBOutlet weak var collectionView2: UICollectionView! {
        didSet {
            collectionView2.allowsSelection = false
        }
    }
    
    @IBOutlet weak var topCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionBottomHeight: NSLayoutConstraint!
    
    private var items1 = Model.allObject()
    private var items2 = [Model]()
    private var didReordering: Bool = true
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let layout = BouncyLayout(style: .regular)
        
       // let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        //layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 12
        //layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        */
        
        let layout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        self.collectionView1?.collectionViewLayout = layout
        self.collectionView1.dragInteractionEnabled = true
        self.collectionView1.dragDelegate = self
        self.collectionView1.dropDelegate = self
        self.collectionView1.delegate = self
        self.collectionView1.reorderingCadence = .immediate
        collectionView1.register(UINib(nibName: "MyCollectionViewCell", bundle: .main),
                                 forCellWithReuseIdentifier: "kMyCollectionViewCell")
        
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        self.collectionView2?.collectionViewLayout = layout2
        self.collectionView2.dragInteractionEnabled = true
        self.collectionView2.dropDelegate = self
        self.collectionView2.dragDelegate = self
        self.collectionView2.reorderingCadence = .slow //default value - .immediate
        collectionView2.register(UINib(nibName: "MyCollectionViewCell", bundle: .main),
                                 forCellWithReuseIdentifier: "kMyCollectionViewCell")
    }
    
    //MARK: Private Methods
    private func reorderItems(coordinator: UICollectionViewDropCoordinator,
                              destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0) {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.collectionView2 {
                    self.items2.remove(at: sourceIndexPath.row)
                    self.items2.insert(item.dragItem.localObject as! Model, at: dIndexPath.row)
                } else {
                    self.items1.remove(at: sourceIndexPath.row)
                    self.items1.insert(item.dragItem.localObject as! Model, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    private func copyItems(coordinator: UICollectionViewDropCoordinator,
                           destinationIndexPath: IndexPath, sourceIndexPath: IndexPath?,
                           collectionView: UICollectionView) {
        
        collectionView.performBatchUpdates({
            var destinationIndeces = [IndexPath]()
            var sourceIndeces = [IndexPath]()
            let firstArray = self.items1
            
            for (index, item) in coordinator.items.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index,
                                          section: destinationIndexPath.section)
                
                let dragItem = item.dragItem.localObject as! Model
                for(index2, itemIndex) in firstArray.enumerated() {
                    if itemIndex == dragItem {
                        let sourceIndie = IndexPath(row: index2, section: destinationIndexPath.section)
                        sourceIndeces.append(sourceIndie)
                        self.items1.remove(at: index2)
                    }
                }
                dragItem.isSelected = !dragItem.isSelected
                self.items2.insert(dragItem, at: indexPath.row)
                destinationIndeces.append(indexPath)
            }
            
            print(destinationIndeces)
            print(sourceIndeces)
            
            if collectionView == collectionView1 {
                print("========= First Collection")
            } else {
                print("========= Second Collection")
            }
            
            collectionView.insertItems(at: destinationIndeces)
            collectionView1.deleteItems(at: sourceIndeces)
            topCollectionViewHeight.constant = collectionView1.intrinsicContentSize.height
            bottomCollectionBottomHeight.constant = 400 +  collectionView1.intrinsicContentSize.height
        })
    }
    
    @IBAction func didTapOnButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "kSecondViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - UICollectionViewDataSource Methods
extension ListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.collectionView1 ? self.items1.count : self.items2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kMyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
            cell.setModel(self.items1[indexPath.row])
            /*cell.label.text = self.items1[indexPath.row].title.capitalized
             cell.isSelected = false*/
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kMyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
            cell.setModel(self.items2[indexPath.row])
            return cell
        }
    }
}

// MARK: - UICollectionViewDragDelegate Methods
extension ListViewController : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let item = collectionView == collectionView1 ? self.items1[indexPath.row] : self.items2[indexPath.row]
        let itemProvider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        itemsForAddingTo session: UIDragSession,
                        at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let item = collectionView == collectionView1 ? self.items1[indexPath.row] : self.items2[indexPath.row]
        let itemProvider = NSItemProvider(object: item.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        if collectionView == collectionView2 {
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 25, y: 25, width: 50, height: 50))
            return previewParameters
        }
        return nil
    }
}

// MARK: - UICollectionViewDropDelegate Methods
extension ListViewController : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView === self.collectionView1 {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        } else {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
            
        case .copy:
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, sourceIndexPath: coordinator.items.first?.sourceIndexPath, collectionView: collectionView)
            
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        /*
        collectionView.performBatchUpdates({
            
            if collectionView === self.collectionView1 && didReordering == false {
                var removeIndexPaths = [IndexPath]()
                let oldItems = self.items1
                let subtractsArray =  Array(Set(oldItems).subtracting(items2))
                self.items1.removeAll()
                self.items1 = subtractsArray
                for (index, item) in oldItems.enumerated() {
                    if subtractsArray.filter({item == $0}).count == 0 {
                        removeIndexPaths.append(IndexPath(item: index, section: 0))
                    }
                }
                collectionView.deleteItems(at: removeIndexPaths)
            }
        }) { (tt) in
            collectionView.reloadData()
        }*/
    }
}

extension ListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView1 {
            let size = self.items1[indexPath.row].size
            //let size = UILabel.textSize(font: UIFont.systemFont(ofSize: 17), text: text)
            return CGSize(width: size.width + 20, height: size.height + 15)
        } else {
            let size = self.items2[indexPath.row].size
            //let size = UILabel.textSize(font: UIFont.systemFont(ofSize: 17), text: text)
            return CGSize(width: size.width + 20, height: size.height  + 15)
        }
    }
}


extension UICollectionView {
    override open var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }
}
