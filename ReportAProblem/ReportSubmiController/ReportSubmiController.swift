//
//  ReportSubmiController.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 11/11/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import UIKit

class ReportSubmiController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout = CollectionViewLayout()
    var selectedItems: [Itemable]?
    var firstDataManipulator: CollectionViewDataManipulator<Item, ReportSubmitCollectionViewCell>? {
        didSet {
            if let collectionView = collectionView {
                //collectionViewLayout.delegate = self
                
                collectionViewLayout.layout?.maxParallaxOffset = 60
                collectionViewLayout.layout?.minimumInteritemSpacing = 5
                collectionViewLayout.layout?.minimumLineSpacing = 10
                
                collectionViewLayout.layout?.headerSize = CGSize(width: 414, height: 260)
                
                
                collectionViewLayout.layout?.itemSize = CGSize(width: self.view.bounds.size.width - 20, height: 120)
                collectionView.collectionViewLayout = collectionViewLayout
                collectionView.dataSource = firstDataManipulator
                collectionView.delegate = firstDataManipulator
                
                collectionView.register(ReportSubmitCollectionViewCell.nib,
                                        forCellWithReuseIdentifier: ReportSubmitCollectionViewCell.reuseIdentifier)
                collectionView.register(CustomListHeader.self,
                                        forSupplementaryViewOfKind: CollectionViewLayout.Element.header.kind,
                                        withReuseIdentifier: CollectionViewLayout.Element.header.id)
                collectionView.register(ShortVideoListHeader.self,
                                        forSupplementaryViewOfKind: CollectionViewLayout.Element.sectionHeader.kind,
                                        withReuseIdentifier: CollectionViewLayout.Element.sectionHeader.id)

            }
        }
    }
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = selectedItems as? [Item] {
            firstDataManipulator = CollectionViewDataManipulator<Item, ReportSubmitCollectionViewCell>(secions:
                [Section<Item>(title: "Please drag the items", items: items, isDragEnabled: true)])
        }
    }

    @IBAction func didClickOnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


extension ReportSubmiController : CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width - 20, height: 120)
    }
}
