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
                collectionViewLayout.layout?.minimumInteritemSpacing = 16
                collectionViewLayout.layout?.minimumLineSpacing = 10
                
                collectionViewLayout.layout?.headerSize = CGSize(width: 414, height: 160)
                
                
                collectionViewLayout.layout?.itemSize = CGSize(width: self.view.bounds.size.width - 32, height: 120)
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
        title = "Report Submit"
        if let items = selectedItems as? [Item] {
            firstDataManipulator = CollectionViewDataManipulator<Item, ReportSubmitCollectionViewCell>(secions:
                [Section<Item>(title: "You had issues on", items: items, isDragEnabled: true)])
        }
    }

    @IBAction func didClickOnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitIssues(_ sender: UIBarButtonItem) {
        AMProgressHUD.show()
        Service.submitSelected(["Error 01", "Eorror 02"]) { [weak self] (response: Response<String>) in
            self?.dismiss(animated: true, completion: nil)
            AMProgressHUD.dismiss()
        }
    }
    
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
            self.collectionViewLayout.layout?.headerSize = CGSize(width: self.collectionView.bounds.width, height: 160)
            self.collectionViewLayout.layout?.sectionsHeaderSize = CGSize(width: self.collectionView.bounds.width, height: 50)
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
}


extension ReportSubmiController : CollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width - 20, height: 120)
    }
}

