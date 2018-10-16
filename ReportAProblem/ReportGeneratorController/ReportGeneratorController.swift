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
    
    var dataMaipulator: CollectionViewDataManipulator? {
        didSet {
            self.collectionView.dataSource = dataMaipulator
            self.collectionView.delegate = dataMaipulator
            self.collectionViewLayout.delegate = dataMaipulator
            
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = collectionViewLayout
        
        collectionView.register(UINib(nibName: "SecondCollectionViewCell", bundle: .main),
                                forCellWithReuseIdentifier: "kSecondCollectionViewCell")
        
        dataMaipulator = CollectionViewDataManipulator(secions:
            [CollectionViewDataManipulator.Section(title: "section1",
                                                   items: [Item(title: "Product 1 heidfds sdfsdf sdf sdfsdf sdf",
                                                                subtitle: "cat 1", rightSubtitle: "1.0"),
                                                           Item(title: "Product 2", subtitle: "cat 2", rightSubtitle: "5.0"),
                                                           Item(title: "Product 5", subtitle: "cat 4", rightSubtitle: "7.0"),
                                                           Item(title: "Mrs Romana Begom Ki", subtitle: "cat 4", rightSubtitle: "7.0"),
                                                           Item(title: "Product 15 ", subtitle: "cat 18", rightSubtitle: "7.0")]),
             CollectionViewDataManipulator.Section(title: "section 2",
                                                   items: [Item(title: "Product 1", subtitle: "cat 1", rightSubtitle: "1.0"),
                                                           Item(title: "Product 2", subtitle: "cat 2", rightSubtitle: "5.0"),
                                                           Item(title: "Product 5", subtitle: "cat 35", rightSubtitle: "7.0"),
                                                           Item(title: "Product aktoo boro dudu", subtitle: "cat 34", rightSubtitle: "7.0"),
                                                           Item(title: "Product 7", subtitle: "cat 33", rightSubtitle: "7.0"),
                                                           Item(title: "Product 5", subtitle: "cat 31", rightSubtitle: "7.0"),
                                                           Item(title: "Product 8", subtitle: "cat 32", rightSubtitle: "7.0")]),
             CollectionViewDataManipulator.Section(title: "section 3",
                                                   items: [Item(title: "Product 1", subtitle: "cat 1", rightSubtitle: "1.0"),
                                                           Item(title: "Product 2", subtitle: "cat 2", rightSubtitle: "5.0"),
                                                           Item(title: "Product 5", subtitle: "cat 35", rightSubtitle: "7.0"),
                                                           Item(title: "Product aktoo boro dudu", subtitle: "cat 34", rightSubtitle: "7.0"),
                                                           Item(title: "Product 7", subtitle: "cat 33", rightSubtitle: "7.0"),
                                                           Item(title: "Product 5", subtitle: "cat 31", rightSubtitle: "7.0"),
                                                           Item(title: "Product 8", subtitle: "cat 32", rightSubtitle: "7.0")]),
             CollectionViewDataManipulator.Section(title: "section 4",
                                                   items: [Item(title: "Product 1 heidfds sdfsdf sdf sdfsdf sdf", subtitle: "cat 1", rightSubtitle: "1.0"),
                                                           Item(title: "Product 2", subtitle: "cat 2", rightSubtitle: "5.0"),
                                                           Item(title: "Product 5", subtitle: "cat 4", rightSubtitle: "7.0"),
                                                           Item(title: "Mrs Romana Begom Ki", subtitle: "cat 4", rightSubtitle: "7.0"),
                                                           Item(title: "Product 15 heelodd ", subtitle: "cat 18", rightSubtitle: "7.0")]),
             CollectionViewDataManipulator.Section(title: "section 5",
                                                   items: [Item(title: "Product 1", subtitle: "cat 1", rightSubtitle: "1.0"),
                                                           Item(title: "Product 2", subtitle: "cat 2", rightSubtitle: "5.0"),
                                                           Item(title: "Product 5", subtitle: "cat 35", rightSubtitle: "7.0"),
                                                           Item(title: "Product aktoo boro dudu", subtitle: "cat 34", rightSubtitle: "7.0"),
                                                           Item(title: "Product 7", subtitle: "cat 33", rightSubtitle: "7.0"),
                                                           Item(title: "Product 5", subtitle: "cat 31", rightSubtitle: "7.0"),
                                                           Item(title: "Product 8", subtitle: "cat 32", rightSubtitle: "7.0")])
            ])
        
        
        
        collectionView.register(ShortVideoListHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
        // collectionView.delegate = currentDataSource as! UICollectionViewDelegate
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: view.bounds.width, height: 100)
    }
}

