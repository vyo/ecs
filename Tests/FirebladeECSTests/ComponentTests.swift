//
//  ComponentTests.swift
//  FirebladeECSTests
//
//  Created by Christian Treffs on 21.10.17.
//

@testable import FirebladeECS
import XCTest

class ComponentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testComponentIdentifier() {
		let p1 = Position(x: 1, y: 2)
		XCTAssert(p1.identifier == Position.identifier)

		let v1 = Velocity(a: 3.14)
		XCTAssert(v1.identifier == Velocity.identifier)
		XCTAssert(v1.identifier != p1.identifier)
		XCTAssert(Velocity.identifier != Position.identifier)
	}

	func testMeasureStaticComponentIdentifier() {
		let number: Int = 10_000
		measure {
			for _ in 0..<number {
				let id = Position.identifier
				_ = id
			}
		}
	}

	func testMeasureComponentIdentifier() {
		let number: Int = 10_000
		let pos = Position(x: 1, y: 2)
		measure {
			for _ in 0..<number {
				let id = pos.identifier
				_ = id
			}
		}
	}

}
