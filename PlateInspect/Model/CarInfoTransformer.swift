//
//  CarInfoTransformer.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 14.01.2025.
//

import Foundation

@objc(CarInfoTransformer)
final class CarInfoTransformer: NSSecureUnarchiveFromDataTransformer {

    static let name = NSValueTransformerName(
      rawValue: String(describing: CarInfoTransformer.self)
  )

    public static func register() {
        let transformer = CarInfoTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }

    override static var allowedTopLevelClasses: [AnyClass] {
        return [
            CarInfoBox.self,
          NSData.self
      ]
    }

    override public class func transformedValueClass() -> AnyClass {
        return CarInfoBox.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }

    override public func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }

        do {
            let box = try NSKeyedUnarchiver.unarchivedObject(
              ofClass: CarInfoBox.self,
              from: data
          )
            return box
        } catch {
            return nil
        }
    }

    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let box = value as? CarInfoBox else {
            return nil
        }

        do {
            let data = try NSKeyedArchiver.archivedData(
              withRootObject: box,
              requiringSecureCoding: true
          )
            return data
        } catch {
            return nil
        }
    }
}
