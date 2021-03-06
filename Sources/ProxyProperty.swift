import Foundation

@propertyWrapper
public struct AnyProxy<EnclosingSelf, Value> {
    private let keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>

    public init(_ keyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>) {
        self.keyPath = keyPath
    }

    @available(*, unavailable, message: "The wrapped value must be accessed from the enclosing instance property.")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    public static subscript(
        _enclosingInstance observed: EnclosingSelf,
        wrapped _: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            let storageValue = observed[keyPath: storageKeyPath]
            let value = observed[keyPath: storageValue.keyPath]
            return value
        }
        set {
            let storageValue = observed[keyPath: storageKeyPath]
            observed[keyPath: storageValue.keyPath] = newValue
        }
    }
}

// Kudos @johnsundell for this trick
// https://swiftbysundell.com/articles/accessing-a-swift-property-wrappers-enclosing-instance/
extension NSObject: ProxyContainer {}
public protocol ProxyContainer {
    typealias Proxy<T> = AnyProxy<Self, T>
}
