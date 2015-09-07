//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchResultsUpdating  {
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchController: UISearchController!
    var filterTerms = [String : AnyObject]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.filteredBusinesses = self.businesses
        self.initSearchController()
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
            
            
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        // cell.business = self.businesses![indexPath.row]
        println("row=\(indexPath.row)")
        cell.business = self.filteredBusinesses![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if( businesses != nil ) {
        //            return businesses!.count
        //        }
        //        else {
        //            return 0
        //        }
        
        if( filteredBusinesses != nil ) {
            return filteredBusinesses!.count
        }
        else {
            return 0
        }
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as!  FiltersViewController
        filtersViewController.delegate = self
        filtersViewController.filters = self.filterTerms
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilter filters: [String : AnyObject]) {
        self.filterTerms = filters
        var categories = filters["categories"] as? [String]
        var isDeal =  filters["deal"] as? Bool
        var tmpSort = filters["sort"] as? Int
        var sortFilter : YelpSortMode?
        if(tmpSort != nil) {
         sortFilter =  YelpSortMode(rawValue: tmpSort!)
        }
        //print("sortFilter=\(sortFilter)")
        Business.searchWithTerm("Restaurants", sort: sortFilter, categories: categories, deals: isDeal){
            (businesses:[Business]!, error: NSError! ) ->Void in
            self.businesses = businesses
            self.filteredBusinesses = self.businesses
            self.tableView.reloadData()
        }
    }
    
    func initSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({if let name = $0.name   {
            return name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        }
        else {
            return false
            }
        })
        
        tableView.reloadData()
    }
    
    
}
