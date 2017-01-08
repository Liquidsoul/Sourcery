//
// Created by Krzysztof Zablocki on 13/09/2016.
// Copyright (c) 2016 Pixle. All rights reserved.
//

import Foundation

/// Defines a variable

final class Variable: NSObject, AutoDiffable, Typed, Annotated, NSCoding {
    /// Variable name
    let name: String

    /// Variable type name
    var typeName: TypeName

    /// sourcery: skipEquality
    /// sourcery: skipDescription
    var type: Type?

    /// Whether is computed
    let isComputed: Bool

    /// Whether this is static variable
    let isStatic: Bool

    /// Read access
    let readAccess: String

    /// Write access
    let writeAccess: String

    /// Annotations, that were created with // sourcery: annotation1, other = "annotation value", alterantive = 2
    var annotations: [String: NSObject] = [:]

    /// Underlying parser data, never to be used by anything else
    /// sourcery: skipEquality, skipDescription
    internal var __parserData: Any?

    init(name: String = "",
         typeName: String = "",
         accessLevel: (read: AccessLevel, write: AccessLevel) = (.internal, .internal),
         isComputed: Bool = false,
         isStatic: Bool = false,
         annotations: [String: NSObject] = [:]) {

        self.name = name
        self.typeName = TypeName(typeName)
        self.isComputed = isComputed
        self.isStatic = isStatic
        self.readAccess = accessLevel.read.rawValue
        self.writeAccess = accessLevel.write.rawValue
        self.annotations = annotations
    }

    // Variable.NSCoding {
        required init?(coder aDecoder: NSCoder) {
             guard let name: String = aDecoder.decode(forKey: "name") else { return nil }; self.name = name
             guard let typeName: TypeName = aDecoder.decode(forKey: "typeName") else { return nil }; self.typeName = typeName

            self.isComputed = aDecoder.decodeBool(forKey: "isComputed")
            self.isStatic = aDecoder.decodeBool(forKey: "isStatic")
             guard let readAccess: String = aDecoder.decode(forKey: "readAccess") else { return nil }; self.readAccess = readAccess
             guard let writeAccess: String = aDecoder.decode(forKey: "writeAccess") else { return nil }; self.writeAccess = writeAccess
             guard let annotations: [String: NSObject] = aDecoder.decode(forKey: "annotations") else { return nil }; self.annotations = annotations

        }

        func encode(with aCoder: NSCoder) {

            aCoder.encode(self.name, forKey: "name")
            aCoder.encode(self.typeName, forKey: "typeName")
            aCoder.encode(self.isComputed, forKey: "isComputed")
            aCoder.encode(self.isStatic, forKey: "isStatic")
            aCoder.encode(self.readAccess, forKey: "readAccess")
            aCoder.encode(self.writeAccess, forKey: "writeAccess")
            aCoder.encode(self.annotations, forKey: "annotations")

        }
        // } Variable.NSCoding
}
