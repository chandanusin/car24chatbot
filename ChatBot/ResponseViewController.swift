//
//  responseViewController.swift
//  ChatBot
//
//  Created by Chandan verma on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import UIKit

class ResponseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Mark: - outlets
    @IBOutlet weak var responseCollectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    fileprivate var modelData:[Any] = [Any]()
    
    /// list of cell class
    fileprivate var cellClass:AnyClass?
    
    /// graphic cell nib name
    fileprivate var cellNibName:String?
    
    /// graphic cell re-use identifier
    fileprivate var cellReuseIdentifier:String?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reload() {
        responseCollectionView?.reloadData()
    }
    
    func setModelData(_ data:[Any]) {
        self.modelData = data
        DispatchQueue.main.async {
            self.reload()
        }
    }
    
    //Mark: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.responseCollectionView.delegate = self as! UICollectionViewDelegate;
        self.responseCollectionView.dataSource = self as! UICollectionViewDataSource;
        self.responseCollectionView.allowsMultipleSelection = true;
        
        self.registerVideoCollectionViewClass(ResponseCollectionViewCell.self,
                                                           nibName:"ResponseCollectionViewCell",
                                                           forCellWithReuseIdentifier: kResponseCollectionViewCellID);
        
        /// register video cell
        if nil != cellNibName {
            self.responseCollectionView.register(UINib(nibName: cellNibName!,bundle:nil), forCellWithReuseIdentifier: cellReuseIdentifier!);
        } else if nil != cellClass {
            self.responseCollectionView.register(cellClass,forCellWithReuseIdentifier: cellReuseIdentifier!);
        }
    }
    
    func registerVideoCollectionViewClass(_ cellClass: AnyClass?,
                                          nibName:String?,
                                          forCellWithReuseIdentifier identifier: String) {
        
        self.cellClass = cellClass
        self.cellNibName = nibName
        self.cellReuseIdentifier = identifier
        
    }
    
    @IBAction func didClickClose(sender: AnyObject) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
}

extension ResponseViewController {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelData.count
        //return 10
    }
    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kResponseCollectionViewCellID, for: indexPath) as! ResponseCollectionViewCell
        if let detail = modelData[indexPath.row] as? ListedCarDetails {
            cell.configureCell(detail: detail)
        }
        return cell
    }
    
    
}


