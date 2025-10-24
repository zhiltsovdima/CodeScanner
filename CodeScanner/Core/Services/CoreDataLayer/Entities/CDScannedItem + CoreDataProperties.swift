//
//  CDScannedItem + CoreDataProperties.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import CoreData
import Foundation

extension CDScannedItem {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDScannedItem> {
        return NSFetchRequest<CDScannedItem>(entityName: "CDScannedItem")
    }

    @NSManaged public var id: String
    @NSManaged public var type: String
    @NSManaged public var scanDate: Date
    @NSManaged public var rawCode: String
    @NSManaged public var productData: Data?
    @NSManaged public var name: String?

}

extension CDScannedItem {
    func toScannedItem() -> ScannedItem? {
        switch type {
        case "qr":
            var content = QRCodeContent(id: id, rawValue: rawCode, date: scanDate)
            content.displayName = name
            return .qr(content)
        case "product":
            guard let data = productData,
                  let vm = try? JSONDecoder().decode(ProductDetailViewModel.self, from: data)
            else { return nil }
            vm.displayName = name
            return .product(vm)
        default:
            return nil
        }
    }
}
