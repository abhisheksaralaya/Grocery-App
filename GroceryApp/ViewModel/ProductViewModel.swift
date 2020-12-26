//
//  ProductViewModel.swift
//  GroceryApp
//
//  Created by Apple on 25/12/20.
//

import Foundation
import Network
import UIKit
import CoreData

class ProductViewModel: NSObject {
    @IBOutlet var apiClient: APIClient!
    
    var categories: [Category]?
//    var issues: [IssueDetails]?
//    var contributors: [Contributor]?
    
    func getData(apiName: String, paramaters: String, completion: @escaping () -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                self.apiClient.fetchRepoList(apiName: apiName, paramaters: paramaters, completion: { (data) in
                    DispatchQueue.main.async {
                        switch apiName {
                        case "getProducts":
                            self.categories = data as? [Category]
                            print("qwertyu",self.categories)
                            break
                        default:
                            break
                        }
                        monitor.cancel()
                        completion()
                    }
                })
            } else {
                //No Internet
                
            }
        }
    }
    
    func categoryCount() -> Int {
        return self.categories?.count ?? 0
    }
    
    func totalItems(section: Int) -> Int {
        return self.categories?[section].total_items ?? 0
    }
    
    func subCategoryCount(section: Int) -> Int {
        return self.categories?[section].subcategories?.count ?? 0
    }
    
    func subCategoryItemsCount(section: Int, row: Int) -> Int {
        return self.categories?[section].subcategories?[row].products?.count ?? 0
        }
    
    func categoryName(section: Int) -> String {
        return self.categories?[section].cat_name ?? ""
    }
    
    
    func subCategoryName(section: Int, row: Int) -> String {
        return self.categories?[section].subcategories?[row].sub_cat_name ?? ""
    }
    
    
    
}
