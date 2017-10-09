//
//  UET.swift
//  FirebladeECS
//
//  Created by Christian Treffs on 09.10.17.
//

// MARK: Unique Event Type
/// Unique Event Type
public struct UET {
	let objectIdentifier: ObjectIdentifier
	let type: Event.Type

	init(_ eventType: Event.Type) {
		objectIdentifier = ObjectIdentifier(eventType)
		type = eventType
	}

	init(_ event: Event) {
		let eventType: Event.Type = event.uet.type
		self.init(eventType)
	}
}

extension UET: Equatable {
	public static func ==(lhs: UET, rhs: UET) -> Bool {
		return lhs.objectIdentifier == rhs.objectIdentifier
	}
}

extension UET: Hashable {
	public var hashValue: Int {
		return objectIdentifier.hashValue
	}
}

// MARK: Unique Event Identifiable
public protocol UniqueEventIdentifiable {
	static var uet: UET { get }
	var uet: UET { get }
}
