//
//  SecondViewController.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 10/9/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import UIKit

class ReportGeneratorController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewLayout = CollectionViewLayout()
    //var selectedItems: [Section<Item>]?
    var selectedModules: [Module]?
    private var collectionDisposable: Disposable?
    var firstDataManipulator: CollectionViewDataManipulator<Item, ReportGeneratorCollectionViewCell>? {
        didSet {
            if let collectionView = collectionView {
                collectionViewLayout.layout?.maxParallaxOffset = 60
                collectionViewLayout.layout?.minimumInteritemSpacing = 5
                collectionViewLayout.layout?.minimumLineSpacing = 10
                collectionViewLayout.layout?.headerSize = CGSize(width: 414, height: 260)
                
                collectionViewLayout.delegate = firstDataManipulator
                collectionView.collectionViewLayout = collectionViewLayout
                collectionView.dataSource = firstDataManipulator
                collectionView.delegate = firstDataManipulator
                
                collectionView.register(ReportGeneratorCollectionViewCell.nib,
                                        forCellWithReuseIdentifier: ReportGeneratorCollectionViewCell.reuseIdentifier)
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
        
        view.accessibilityIdentifier = "__page__ReportGeneratorController"
        
        if let items = selectedModules {
            
           firstDataManipulator = CollectionViewDataManipulator<Item, ReportGeneratorCollectionViewCell>(secions: items.map { module in
                Section<Item>(title: module.feature, items: ListViewModel.reportModels(module: module), isDragEnabled: false)
            })
        }
        
//        collectionDisposable = Observable(firstDataManipulator?.sections).observe { ([Section<Item>)]? in
//            print(section?.makeIterator().count)
//
//        }
        
        
        
//        collectionDisposable = firstDataManipulator?.getSelectedItems().observe({ (items: [Item]?) in
//            print(items?.count ?? 0)
//        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "kReportSubmitController") {
            if let navController = segue.destination as? UINavigationController,
                let reportSubmit = navController.topViewController as? ReportSubmiController {
                reportSubmit.selectedItems = firstDataManipulator?.getSelectedItems()
            }
        }
    }
}

