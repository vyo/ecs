//
//  FamilyTraitSet.swift
//  FirebladeECS
//
//  Created by Christian Treffs on 09.10.17.
//

public struct FamilyTraitSet {

	private let requiresAll: ComponentSet
	private let excludesAll: ComponentSet
	private let needsAtLeastOne: ComponentSet
	private let setHash: Int
	private let isEmptyAny: Bool

	public init(requiresAll: [Component.Type], excludesAll: [Component.Type], needsAtLeastOne: [Component.Type] = []) {

		let all = ComponentSet(requiresAll.map { $0.identifier })
		let none = ComponentSet(excludesAll.map { $0.identifier })
		let one = ComponentSet(needsAtLeastOne.map { $0.identifier })

		let valid: Bool = FamilyTraitSet.isValid(requiresAll: all, excludesAll: none, atLeastOne: one)
		assert(valid, "invalid family trait created - requiresAll: \(all), excludesAll: \(none), atLeastOne: \(one)")

		isEmptyAny = one.isEmpty

		setHash = hash(combine: [all, one, none])

		self.requiresAll = all
		self.needsAtLeastOne = one
		self.excludesAll = none
	}

	// MARK: - match
	public func isMatch(components: ComponentSet) -> Bool {
		return hasAll(components) && hasNone(components) && hasOne(components)
	}

	private func hasAll(_ components: ComponentSet) -> Bool {
		return requiresAll.isSubset(of: components)
	}

	private func hasNone(_ components: ComponentSet) -> Bool {
		return excludesAll.isDisjoint(with: components)
	}

	private func hasOne(_ components: ComponentSet) -> Bool {
		if needsAtLeastOne.isEmpty {
			return true
		}
		return !needsAtLeastOne.isDisjoint(with: components)
	}

	// MARK: - valid
	static func isValid(requiresAll: ComponentSet, excludesAll: ComponentSet, atLeastOne: ComponentSet) -> Bool {
		return validAtLeastOneNonEmpty(requiresAll, atLeastOne) &&
			requiresAll.isDisjoint(with: atLeastOne) &&
			requiresAll.isDisjoint(with: excludesAll) &&
			atLeastOne.isDisjoint(with: excludesAll)
	}

	static func validAtLeastOneNonEmpty(_ requiresAll: ComponentSet, _ atLeastOne: ComponentSet) -> Bool {
		return !requiresAll.isEmpty || !atLeastOne.isEmpty
	}

}

// MARK: - Equatable
extension FamilyTraitSet: Equatable {
	public static func == (lhs: FamilyTraitSet, rhs: FamilyTraitSet) -> Bool {
		return lhs.setHash == rhs.setHash
	}
}

// MARK: - Hashable
extension FamilyTraitSet: Hashable {
	public var hashValue: Int {
		return setHash
	}
}
