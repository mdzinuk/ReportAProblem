//
//  CustomViewController.swift
//  DragAndDropInCollectionView
//
//  Created by Mohammad Arafat Hossain on 6/10/18.
//  Copyright © 2018 Payal Gupta. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView1: UICollectionView! {
        didSet {
            collectionView1.reloadData()
            collectionView1.backgroundColor = UIColor.black.withAlphaComponent(0.015)
            collectionView1.accessibilityIdentifier = "__page__ListViewController"
        }
    }
    
    @IBOutlet weak var contentHeight: NSLayoutConstraint! {
        didSet {
            //contentHeight.priority = UILayoutPriority.defaultHigh
            //contentHeight.constant = collectionViewLayout1.contentBounds.height
        }
    }
    
    private var collectionDisposable: Disposable?
    let collectionViewLayout1 = CollectionViewLayout()
    var dataModules = [Module]()
    
    @IBOutlet weak var nextButton: UIButton!{
        didSet {
            self.nextButton.layer.cornerRadius = self.nextButton.bounds.size.height/2
            self.nextButton.layer.borderWidth = 1.0
            self.nextButton.backgroundColor = .white
            self.nextButton.layer.borderColor = UIColor.lightGray.cgColor
            self.nextButton.layer.masksToBounds = true
            self.nextButton.layer.shadowColor = UIColor.gray.cgColor
            self.nextButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            self.nextButton.layer.shadowRadius = 2.0
            self.nextButton.layer.shadowOpacity = 0.9
            self.nextButton.layer.masksToBounds = false
            let attributedText =  NSMutableAttributedString(string: Icon.IconLibrary.create.rawValue,
                                                            attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.red])
            self.nextButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
    var firstDataManipulator: CollectionViewDataManipulator<Item, ListCollectionViewCell>? {
        didSet {
            if let collectionView = collectionView1 {
                collectionViewLayout1.layout?.maxParallaxOffset = 60
                collectionViewLayout1.layout?.minimumInteritemSpacing = 10
                collectionViewLayout1.layout?.minimumLineSpacing = 10
                collectionViewLayout1.layout?.headerSize = CGSize(width: 414, height: 260)
                
                
                collectionViewLayout1.delegate = firstDataManipulator
                collectionView.collectionViewLayout = collectionViewLayout1
                collectionView.dragInteractionEnabled = true
                collectionView.dataSource = firstDataManipulator
                collectionView.delegate = firstDataManipulator
                collectionView.dragDelegate = firstDataManipulator
                collectionView.dropDelegate = firstDataManipulator
                
                collectionView.register(ListCollectionViewCell.nib,
                                        forCellWithReuseIdentifier: ListCollectionViewCell.reuseIdentifier)
                
                collectionView.register(CustomListHeader.self,
                                        forSupplementaryViewOfKind: CollectionViewLayout.Element.header.kind,
                                        withReuseIdentifier: CollectionViewLayout.Element.header.id)
                collectionView.register(ShortVideoListHeader.self,
                                        forSupplementaryViewOfKind: CollectionViewLayout.Element.sectionHeader.kind,
                                        withReuseIdentifier: CollectionViewLayout.Element.sectionHeader.id)
                collectionView.register(CustomListHeader.self,
                                        forSupplementaryViewOfKind: CollectionViewLayout.Element.sectionFooter.kind,
                                        withReuseIdentifier: CollectionViewLayout.Element.sectionFooter.id)
            }
        }
    }
    
    //MARK: View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AMProgressHUD.show()
        Service<[Module]>.loadJSON("reports") { [weak self] (response: Response<[Module]>) in
            switch response {
            case .success(let modules):
                if let allModules = modules {
                    self?.dataModules = allModules
                    self?.firstDataManipulator = CollectionViewDataManipulator<Item, ListCollectionViewCell>(secions:
                        [Section<Item>(title: "Please drag the items",
                                       items: ListViewModel.listModels(modules: allModules),
                                       isDragEnabled: true),
                         Section<Item>(title: "Drop please",
                                       items: [/*ListViewModel.customModel()*/],
                                       isDragEnabled: false)
                        ])
                    AMProgressHUD.dismiss()
                }
            case .failure(let status, let reason):
                print(reason ?? "" + "\(status)")
                AMProgressHUD.dismiss()
            }
        }
        
        collectionDisposable = Observable(collectionViewLayout1.contentBounds.height).observe { [weak self] height in
            //self?.contentHeight.constant = max(min(height, (UIScreen.main.bounds.height - 100)), 600)
        }
    }
    
    @IBAction func didTapOnButton(_ sender: UIButton) {
        /*
        if let specialItems = firstDataManipulator?.getSpecialItems() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "kReportComposeViewController") as? ReportComposeViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else*/
        
        guard let selectedItems = firstDataManipulator?.getSelectedItems() else { return }
        if let specialItem = selectedItems.filter({$0.isSpecial == true}).first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "kReportComposeViewController") as? ReportComposeViewController {
                //self.navigationController?.pushViewController(vc, animated: true)
                self.present(vc, animated: true, completion: nil)
            }
        } else {
            var ddd = [Module]()
            self.dataModules.forEach { (module) in
                selectedItems.forEach({ (item) in
                    if item.subtitle == module.feature {
                        ddd.append(module)
                    }
                    print(item.subtitle)
                })
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "kReportGeneratorController") as? ReportGeneratorController {
                vc.selectedModules = ddd
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        
        
        /*
         firstDataManipulator?.sections.forEach({ (item: CollectionViewDataManipulator<Item, ListCollectionViewCell>.Section<Item>) in
         print(item.title)
         })*/
    }
    
    var intrinsicContentSize: CGSize {
        return collectionView1.collectionViewLayout.collectionViewContentSize
    }
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView1.collectionViewLayout.invalidateLayout()
        self.collectionView1.layoutIfNeeded()
    }
}


