//
//  SwiftTemplateSpecs.swift
//  Sourcery
//
//  Created by Krunoslav Zaher on 12/30/16.
//  Copyright © 2016 Pixle. All rights reserved.
//

import Foundation
import Quick
import Nimble
import PathKit
@testable import Sourcery
@testable import SourceryRuntime

class SwiftTemplateTests: QuickSpec {
    override func spec() {
        describe("SwiftTemplate") {
            let outputDir: Path = {
                return Stubs.cleanTemporarySourceryDir()
            }()

            let templatePath = Stubs.swiftTemplates + Path("Equality.swifttemplate")
            let expectedResult = try? (Stubs.resultDirectory + Path("Basic.swift")).read(.utf8)

            it("generates correct output") {
                expect { try Sourcery(cacheDisabled: true).processFiles(.sources(Paths(include: [Stubs.sourceDirectory])), usingTemplates: Paths(include: [templatePath]), output: outputDir) }.toNot(throwError())

                let result = (try? (outputDir + Sourcery().generatedPath(for: templatePath)).read(.utf8))
                expect(result).to(equal(expectedResult))
            }

            it("throws an error showing the involved line for unmatched delimiter in the template") {
                let templatePath = Stubs.swiftTemplates + Path("InvalidTag.swifttemplate")
                expect {
                    try SwiftTemplate(path: templatePath)
                    }
                    .to(throwError(closure: { (error) in
                        expect("\(error)").to(equal("\(templatePath):2 Error while parsing template. Unmatched <%"))
                    }))
            }

            it("rethrows template parsing errors") {
                let templatePath = Stubs.swiftTemplates + Path("Invalid.swifttemplate")
                expect {
                    try Generator.generate(Types(types: []), template: SwiftTemplate(path: templatePath))
                    }
                    .to(throwError(closure: { (error) in
                        let path = Path.cleanTemporaryDir(name: "build") + "main.swift"
                        expect("\(error)").to(equal("\(path):6:13: error: expected expression in list of expressions\n  print(\"\\( )\", terminator: \"\");\n            ^\n"))
                    }))
            }

            it("rethrows template runtime errors") {
                let templatePath = Stubs.swiftTemplates + Path("Runtime.swifttemplate")
                expect {
                    try Generator.generate(Types(types: []), template: SwiftTemplate(path: templatePath))
                    }
                    .to(throwError(closure: { (error) in
                        expect("\(error)").to(equal("\(templatePath): Unknown type Some, should be used with `based`"))
                    }))
            }
        }
    }
}
