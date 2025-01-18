//
//  CarInfoEntity+CoreDataProperties.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 14.01.2025.
//
//

import Foundation
import CoreData


extension CarInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarInfoEntity> {
        return NSFetchRequest<CarInfoEntity>(entityName: "CarInfoEntity")
    }

    @NSManaged public var carInfo: CarInfoBox?

}

extension CarInfoEntity : Identifiable {

}
