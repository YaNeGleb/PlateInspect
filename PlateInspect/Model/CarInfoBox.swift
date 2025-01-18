//
//  CarInfoBox.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 14.01.2025.
//

import Foundation

public final class CarInfoBox: NSObject {
    let unbox: CarInfo
    init(_ value: CarInfo) {
        self.unbox = value
    }
}

extension CarInfo {
    var boxed: CarInfoBox {
      return CarInfoBox(self)
  }
}

extension CarInfoBox: NSSecureCoding {
    public static var supportsSecureCoding: Bool {
        return true
    }

    public func encode(with coder: NSCoder) {
        do {
          let encoder = JSONEncoder()
            let data = try encoder.encode(unbox)
            coder.encode(data, forKey: "unbox")

        } catch let codableError {
            print(codableError)
        }
    }

    convenience public init?(coder: NSCoder) {
        if let data = coder.decodeObject(of: NSData.self, forKey: "unbox") {
            do {
            let decoder = JSONDecoder()
                let b = try decoder.decode(
                    CarInfo.self,
                  from: (data as Data)
              )
                self.init(b)

            } catch let codableError {
                print(codableError)
                return nil
            }
        } else {
            return nil
        }
    }
}
