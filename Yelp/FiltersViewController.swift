//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Do Ngoc Tan on 9/5/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    
    optional  func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilter filters: [String:AnyObject])
    
}

struct SectionSwitchState {
    var sectionName:String = ""
    
    
    
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, ExpandFilterCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var categories: [[String:String]]!
    
    weak var delegate: FiltersViewControllerDelegate?
    let HeaderViewIdentifier = "FilterHeaderView"
    var sections = ["Deal", "Sort", "Distance", "Categories"]
    var sectionRows = ["Sort": 1, "Distance": 1, "Deal": 1, "Categories": 4]
    var sorts: [String] = ["Best Match","Distance","Rating"]
    var expandHeader : [String:Bool]! = ["Sort": false, "Distance": false,"Categories":false]
    var radiusOption: [String] = ["Best Match",
        "2 blocks",
        "6 blocks",
        "1 mile",
        "5 miles"]
    let radiusValues: [String:Float?] = ["Best Match": nil,
        "2 blocks": 200.0,
        "6 blocks": 600.0,
        "1 mile": 1609.34,
        "5 miles": 8046.72]
    var sortFilter:[String:YelpSortMode] = ["Best Match":YelpSortMode.BestMatched, "Distance": YelpSortMode.Distance, "Rating": YelpSortMode.HighestRated]
    var filters = [String : AnyObject]()
    var sectionSwitchStates:[SectionSwitchState] = []
    var switchStates = [Int:Bool]()
    var checkedDistance: [Bool]!
    var checkedSort: [Bool]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        self.categories = self.yelpCategories()
        tableView.reloadData()
        self.checkedDistance = [Bool](count: radiusOption.count, repeatedValue: false)
        self.checkedSort = [Bool](count: self.sorts.count, repeatedValue: false)
        if(filters["sort"] != nil) {
            var idx = filters["sort"] as! Int
            checkedSort[idx] = true
        }
        if(filters["distance"] != nil) {
            // var idx = filters["distance"] as! Int
            // checkedSort[idx] = true
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let sectionName = sections[indexPath.section]
        if( sectionName == "Sort" ) {
            self.checkedSort[indexPath.row] = !checkedSort[indexPath.row]
            for( var i=0; i<checkedSort.count;++i) {
                if( i != indexPath.row ) {
                    checkedSort[i] = false//
                }
            }
        }
        else  if( sectionName == "Distance") {
            checkedDistance[indexPath.row] = !checkedDistance[indexPath.row]
            
            for( var i=0; i<checkedDistance.count;++i) {
                if( i != indexPath.row ) {
                    checkedDistance[i] = false//
                }
            }
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var sectionCount = indexPath.section
        let sectionName = sections[sectionCount]
        var row = indexPath.row
        switch sectionName {
            
        case "Sort":
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ExpandFilterCell") as! ExpandFilterCell
            cell.lbExpandGuide.text = self.sorts[row]
            cell.lbExpandGuide.textAlignment = NSTextAlignment.Left
            if checkedSort[row] {
                cell.accessoryType = .Checkmark
                if(filters["sort"] == nil) {
                    filters["sort"] = YelpSortMode.BestMatched.rawValue
                }
                else {
                    self.filters["sort"] = self.sortFilter[sorts[row]]?.rawValue
                }
                
                //self.editing = !self.editing
                // tableView.moveRowAtIndexPath(indexPath,toIndexPath: NSIndexPath(index:0))
                //                var itemToMove = sorts[row]
                //                self.sorts.removeAtIndex(row)
                //                sorts.insert(itemToMove, atIndex: 0)
                // tableView.reloadSections(NSIndexSet(index: sectionCount), withRowAnimation: UITableViewRowAnimation.Fade)
                // tableView.reloadData()
            } else {
                cell.accessoryType = .None
            }
            return cell
            
        case "Distance":
            let cell = tableView.dequeueReusableCellWithIdentifier("ExpandFilterCell") as! ExpandFilterCell
            cell.lbExpandGuide.text = self.radiusOption[row]
            cell.lbExpandGuide.textAlignment = NSTextAlignment.Left
            if checkedDistance[row] {
                cell.accessoryType = .Checkmark
                filters["distance"] = self.radiusValues[self.radiusOption[row]]!
                
                
            } else {
                cell.accessoryType = .None
            }
            
            return cell
            
        case "Deal":
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
            cell.lbSwitch.text = "Offering A Deal"
            if let isOn = filters["deal"] as? Bool {
                cell.onSwitch.on = isOn
            }
            else {
                cell.onSwitch.on = false
            }
            // cell.onSwitch.on = filters["deal"] as? Bool?? false
            cell.delegate = self
            return cell
            
        case "Categories":
                      
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! SwitchCell
                let titleCat = categories[indexPath.row]["name"]
                //cell.onSwitch.on = false
                if let  selectedCategories  = self.filters["categories"] as? [String] {
                    if let categoryCode = categories[indexPath.row]["code"] {
                        for category in selectedCategories {
                            if( category == categoryCode ) {
                                cell.onSwitch.on = true
                                break
                            }
                            else {
                                cell.onSwitch.on = false
                            }
                        }
                    }
                }
                cell.lbSwitch.text = titleCat
                // cell.onSwitch.on = switchStates[indexPath.row] ?? false
                cell.delegate = self
                return cell
            
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var sectionCount = fromIndexPath.section
        let sectionName = sections[sectionCount]
        if(sectionName == "Sort") {
            var itemToMove = sorts[fromIndexPath.row]
            self.sorts.removeAtIndex(fromIndexPath.row)
            sorts.insert(itemToMove, atIndex: toIndexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nbRows = sectionRows[sections[section]] {
            return nbRows
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 50))
        headerView.tag = section;
        headerView.backgroundColor = UIColor.redColor()
        let sectionName = sections[section]
        var title = UILabel(frame: CGRectMake(10, 10, headerView.frame.width - 70, 30))
        title.text = sectionName
        title.textAlignment = NSTextAlignment.Center
        title.textColor = UIColor.darkTextColor()
        headerView.addSubview(title)
        
        var headerGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("sectionHeaderTapped:"))
        
        headerView.addGestureRecognizer(headerGesture)
        return headerView;
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func sectionHeaderTapped(gestureRecognizer:UITapGestureRecognizer){
        if let section = gestureRecognizer.view?.tag {
            //stateArray[section] = !stateArray[section]
            let sectionName = sections[section]
            if( sectionName == "Categories") {
                if(self.expandHeader["Categories"] == false ) {
                    sectionRows["Categories"] = categories.count
                    self.expandHeader["Categories"] = true
                }
                else {
                    sectionRows["Categories"] = 4
                    self.expandHeader["Categories"] = false
                }
                
                
            }
                
            else if( sectionName == "Sort") {
                if(self.expandHeader["Sort"] == false ) {
                    sectionRows["Sort"] = sorts.count
                    self.expandHeader["Sort"] = true
                }
                else {
                    sectionRows["Sort"] = 1
                    self.expandHeader["Sort"] = false
                }
                // self.expandHeader["Sort"] = !self.expandHeader["Sort"]
            }
                
            else if( sectionName == "Distance") {
                if(self.expandHeader["Distance"] == false ) {
                    sectionRows["Distance"] = self.radiusValues.count
                    self.expandHeader["Distance"] = true
                }
                else {
                    sectionRows["Distance"] = 1
                    self.expandHeader["Distance"] = false
                }
                // self.expandHeader["Sort"] = !self.expandHeader["Sort"]
            }
            
            self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Fade)
            
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangedValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        var sectionCount = indexPath.section
        let sectionName = sections[sectionCount]
        
        
        if(sectionName == "Categories") {
            var code = self.categories[indexPath.row]["code"]! as String
            
            if(filters["categories"] == nil) {
                filters["categories"] = [String]()
            }
            var tmpFilters = filters["categories"] as! [String]
            var idx = find(tmpFilters, code)
            if(value) {
                if( idx == nil) {
                    tmpFilters.append(code)
                }
            }
            else {
                if(idx != nil) {
                    tmpFilters.removeAtIndex(idx!)
                }
            }
            //tmp = NSSet(array: tmp).allObjects as! [String]
            self.filters["categories"] = tmpFilters
        }
        
        if(sectionName == "Deal") {
            self.filters["deal"] = value
        }
        
        
        
        
    }
    
    func expandFilterCell(expandFilterCell: ExpandFilterCell, didChangedValue value: Bool) {
        
    }
    
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
        //        var selectedCategories = [String]()
        //        for (row,isSelected) in switchStates {
        //            if(isSelected) {
        //                selectedCategories.append(self.categories[row]["code"]!)
        //
        //            }
        //
        //        }
        //
        //                if(selectedCategories.count > 0) {
        //            filters["categories"] = selectedCategories
        //        }
        delegate?.filtersViewController?(self, didUpdateFilter: filters)
    }
    
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func yelpCategories() -> [[String:String]] {
        let yelpCat = [["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            
            
        ]
        return yelpCat
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
