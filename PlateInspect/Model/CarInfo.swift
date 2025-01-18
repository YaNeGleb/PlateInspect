//
//  CarInfo.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import Foundation

// MARK: - CarInfo
struct CarInfo: Codable, Equatable {
    let digits: String
    let vin: String?
    let region: Region
    let vendor, model: String
    let modelYear: Int
    let photoURL: String?
    let isStolen: Bool
    let operations: [OperationElement]
    let comments: [Comment]

    enum CodingKeys: String, CodingKey {
        case digits, vin, region, vendor, model
        case modelYear = "model_year"
        case photoURL = "photo_url"
        case isStolen = "is_stolen"
        case operations, comments
    }
}

// MARK: - Comment
struct Comment: Codable, Equatable {
    let id: Int
    let name, text, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, text
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - OperationElement
struct OperationElement: Codable, Equatable {
    let isLast: Bool
    let catalogModelTitle, catalogModelSlug: String?
    let body, purpose: Body?
    let registeredAt: String?
    let modelYear: Int
    let vendor, vendorSlug, model: String
    let operation: OperationOperation
    let department: String
    let color: Color
    let isRegisteredToCompany: Bool
    let address: String
    let koatuu, displacement: Int
    let kind: Kind
    let operationGroup: Body

    enum CodingKeys: String, CodingKey {
        case isLast = "is_last"
        case catalogModelTitle = "catalog_model_title"
        case catalogModelSlug = "catalog_model_slug"
        case body, purpose
        case registeredAt = "registered_at"
        case modelYear = "model_year"
        case vendor
        case vendorSlug = "vendor_slug"
        case model, operation, department, color
        case isRegisteredToCompany = "is_registered_to_company"
        case address, koatuu, displacement, kind
        case operationGroup = "operation_group"
    }
}

// MARK: - Body
struct Body: Codable, Equatable {
    let id: Int?
    let ua, ru: String?
}

// MARK: - Color
struct Color: Codable, Equatable {
    let slug, ru, ua: String
    let id: Int?
}

// MARK: - OperationOperation
struct OperationOperation: Codable, Equatable {
    let ru, ua: String?
}

// MARK: - Kind
struct Kind: Codable, Equatable {
    let id: Int
    let ru, ua, slug: String
}

// MARK: - Region
struct Region: Codable, Equatable {
    let name, nameUa, slug: String
    let oldCode: String?
    let newCode: String

    enum CodingKeys: String, CodingKey {
        case name
        case nameUa = "name_ua"
        case slug
        case oldCode = "old_code"
        case newCode = "new_code"
    }
}


