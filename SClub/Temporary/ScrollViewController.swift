//
//  ScrollViewController.swift
//  SClub
//
//  Created by Sultan on 04.05.2020.
//  Copyright © 2020 com.Sultan. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = .red
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 667)
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
        scrollView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.title = "ХУЙ"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        //navigationItem.searchController = nil

        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
   
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.keyboardDismissMode = .onDrag
        navigationItem.hidesSearchBarWhenScrolling = true
        print("fewfw")
    }
    
}


extension ScrollViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print()
    }
}
