//
//  ViewController.swift
//  GroceryApp
//
//  Created by Apple on 25/12/20.
//

import UIKit

protocol changeHeightDelegate {
    func changeHeight (rowNo: Int)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, changeHeightDelegate {
    
    
    @IBOutlet var productViewModel: ProductViewModel!

    @IBOutlet weak var imgStoreLogo: UIImageView!
    @IBOutlet weak var imgStoreWall: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var lblItem: UILabel!
    
    var rowsInserted = [String]()
    
    var rows : Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        productViewModel.getData(apiName: "getProducts", paramaters: "", completion:  {
            self.tblItems.dataSource = self
            self.tblItems.delegate = self
            self.tblItems.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productViewModel.categoryCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.subCategoryCount(section: section)
    }
    
    func addRows(section: Int) -> Int {
        var sum = 0
        for value in rowsInserted {
            if value.contains("\(section)_") {
                sum += 1
            }
        }
        return sum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? CategoryTableViewCell {
                cell.lblCategoryName?.text = productViewModel.categoryName(section: indexPath.section)
                cell.lblCategoryItemsCount.text = "\(productViewModel.totalItems(section: indexPath.section)) items"
                return cell
            }
        } else {
//            if
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId1", for: indexPath) as? SubCategoryAndProductTableViewCell {
                cell.rowNo = indexPath.row
                cell.productViewModel = productViewModel
                cell.delegate = self
//                cell.tblSubAndProduct.dataSource = self
//                cell.tblSubAndProduct.delegate = self
//                cell.tblSubAndProduct.reloadData()
                
                return cell
            }
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId1", for: indexPath) as! SubCategoryTableViewCell
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row != 0 {
//            print("sdfgh",productViewModel.subCategoryItemsCount(indexPath: indexPath))
//            let cell = tableView.cellForRow(at: indexPath) as! SubCategoryAndProductTableViewCell
//            cell.tblSubAndProduct.reloadData()
//        lastIndexPath = indexPath
//        tblItems.reloadData()
            
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let count = productViewModel?.subCategoryItemsCount(section: indexPath.section, row: indexPath.row), count > 0, rows == indexPath.row {
            if tableView.rowHeight > 52 {
                return 52
            } else {
                return CGFloat(52 + (136 * count - 1))
            }
        } else {
            return 52
        }
        
    }
    
    
    func changeHeight(rowNo: Int) {
        rows = rowNo
        tblItems.reloadData()
    }
}


class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblCategoryItemsCount: UILabel!
    override func awakeFromNib() {
        layoutIfNeeded()
    }
}

class SubCategoryAndProductTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tblSubAndProduct: UITableView!
    var productViewModel:ProductViewModel? {
        didSet {
            tblSubAndProduct.dataSource = self
            tblSubAndProduct.delegate = self
        }
    }
    var changeHeight:Bool = false
    var rowNo: Int?
    
    
    var delegate: changeHeightDelegate?
    override func awakeFromNib() {
        layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel?.subCategoryItemsCount(section: section, row: rowNo!) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId2", for: indexPath) as? SubCategoryTableViewCell {
                cell.lblSubCategoryName?.text = productViewModel!.subCategoryName(section:indexPath.section , row: rowNo!)
//                cell.lblCategoryItemsCount.text = "\(productViewModel.totalItems(section: indexPath.section)) items"
                return cell
            }
        } else {
//            if
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellId3", for: indexPath) as? ProductTableViewCell {
                
                return cell
            }
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId2", for: indexPath) as! SubCategoryTableViewCell
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.changeHeight(rowNo: rowNo!)
    }
}

class SubCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSubCategoryName: UILabel!
    override func awakeFromNib() {
        layoutIfNeeded()
    }
}


class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductDetails: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var conBtnAddHt: NSLayoutConstraint!
    @IBOutlet weak var conViewPlusMinusHt: NSLayoutConstraint!
    override func awakeFromNib() {
        layoutIfNeeded()
    }
}

