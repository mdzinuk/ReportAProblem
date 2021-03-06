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
    
    @IBOutlet weak var nextButton: UIButton! {
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
                                                            attributes: [NSAttributedString.Key.font: UIFont(name: Icon.IconFont.material.rawValue, size: Icon.IconSize.medium.rawValue) ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.orange])
            self.nextButton.setAttributedTitle(attributedText, for: .normal)
        }
    }
    var firstDataManipulator: CollectionViewDataManipulator<Item, ListCollectionViewCell>? {
        didSet {
            if let collectionView = collectionView1 {
                collectionViewLayout1.layout?.maxParallaxOffset = 60
                collectionViewLayout1.layout?.minimumInteritemSpacing = 10
                collectionViewLayout1.layout?.minimumLineSpacing = 10
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
                         Section<Item>(title: "Drop the items here",
                                       items: [ListViewModel.customModel()],
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
        guard let selectedItems = firstDataManipulator?.getSelectedItems() else { return }
        if let _ = selectedItems.filter({$0.isSpecial == true}).first {
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
                    
                    let t = "Remove app from simulator after Apple is complete · Issue #3935 ... https://github.com/fastlane/fastlane/issues/3935 Mar 24, 2016 - Is there a way to delete the app after snapshot has successfully completed? ... TKBurner added the tool: fastlane label on Mar 25, 2016."
                    
                    self.detectLanguage(with: t)
                    self.getTokenization(with: t)
                    self.getNamedEntityRecognition(with: t)
                    self.getLemmatization(with: t)
                })
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "kReportGeneratorController") as? ReportGeneratorController, ddd.count > 0 {
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
        var headerHeight:CGFloat = 160.0
        var sectionHeight:CGFloat = 40.0
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            let orient = UIApplication.shared.statusBarOrientation
            switch orient {
            case .landscapeLeft,.landscapeRight :
                headerHeight = 90.0
                sectionHeight = 32.0
            default:
                headerHeight = 160.0
                sectionHeight = 40.0
            }
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //AMProgressHUD.dismiss()
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
            self.collectionViewLayout1.layout?.headerSize = CGSize(width: self.collectionView1.bounds.width, height: headerHeight)
            self.collectionViewLayout1.layout?.sectionsHeaderSize = CGSize(width: self.collectionView1.bounds.width, height: sectionHeight)
            self.collectionView1.collectionViewLayout.invalidateLayout()
        })
        super.willTransition(to: newCollection, with: coordinator)
    }
}

extension ListViewController{
    
    //    (1) First method detects the language using .language property of NSLinguisticTagger
    func detectLanguage(with textLabel:String) {
        let l = enumerate(scheme: .language, label: textLabel)
        print("Languagess ===========: ")
        print(l)
        print("===========")
    }
    
    //(2) Tokenization - Segmenting into words, sentences, paragraphs etc
    func getTokenization(with textLabel:String){
        let l = enumerate(scheme: .tokenType, label: textLabel)
        
        print("Tokenization ===========: ")
        print(l)
        print("===========")
    }
    
    //(3) Named Entity Recognition
    func getNamedEntityRecognition(with textLabel: String) {
        
        let l = enumerate(scheme: .nameType, label: textLabel)
        print("Named Entity ===========: ")
        print(l)
        print("===========")
        
        
    }
    //(4) Lemmatization - Finding the root of words
    func getLemmatization(with textLabel: String){
        let l = enumerate(scheme: .lemma, label: textLabel)
        print("Lemmatization ===========: ")
        print(l)
        print("===========")
    }
}

extension ListViewController {
    func enumerate(scheme:NSLinguisticTagScheme, label: String) -> [String]? {
        print(label)
        var keywords = [String]()
        var tokens = [String]()
        var lemmas = [String]()
        var range: NSRange = NSRange(location:0, length: label.utf16.count)
        
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName, .noun, .verb]
        
        let tagger = NSLinguisticTagger(tagSchemes: [scheme], options: 0)
        tagger.string = label
        
        
        
        tagger.enumerateTags(in: range, unit: .sentence, scheme: scheme, options: [NSLinguisticTagger.Options.omitPunctuation, NSLinguisticTagger.Options.omitWhitespace]) {
            tag, tokenRange, _ in
            
            switch(scheme){
            case NSLinguisticTagScheme.lemma:
                if let lemma = tag?.rawValue {
                    lemmas.append(lemma)
                }
                break
            case NSLinguisticTagScheme.language:
                print("Dominant language: \(tagger.dominantLanguage ?? "Undetermined ")")
                break
            case NSLinguisticTagScheme.nameType:
                if let tag = tag, tags.contains(tag) {
                    let name = (label as NSString).substring(with: tokenRange)
                    print("entity: \(name)")
                    keywords.append(name)
                }
                break
            case NSLinguisticTagScheme.lexicalClass:
                break
            case NSLinguisticTagScheme.tokenType:
                if let tagVal = tag?.rawValue {
                    tokens.append(tagVal.lowercased())
                }
                break
            default:
                break
            }
            
        }
        
        if (scheme == .nameType){
            print("keywords \(keywords)")
            return keywords
        }else if (scheme == .lemma){
            print("lemmas \(lemmas)")
            return lemmas
        }else if (scheme == .tokenType){
            print("tokens \(tokens)")
            return tokens
        }
        return nil
    }
}
