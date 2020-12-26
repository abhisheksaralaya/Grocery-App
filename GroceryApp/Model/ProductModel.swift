//
//  ProductModel.swift
//  GroceryApp
//
//  Created by Apple on 26/12/20.
//

import Foundation


struct Category: Codable {
    var cat_id, total_items: Int?
    var sub_cat_available: Bool?
    var cat_name, status :String?
    var subcategories: [Subcategory]?
}

struct Subcategory: Codable {
    var sub_cat_id, total_items : Int?
    var sub_cat_name: String?
    var products: [Product]?
}

struct Product: Codable {
    var id, category_id, status: Int?
    var   image, name, price, sale_price, short_description : String?
    var is_prescription_needed, is_taxable, max_quantity_allowed, out_of_stock, quantit, store_id, sub_category_id, type : Int?
}

