import Foundation

extension KeyedDecodingContainer {

    func decode<T>(_ key: KeyedDecodingContainer<K>.Key) throws -> T where T : Decodable {
        try decode(T.self, forKey: key)
    }

    func decodeIfPresent<T>(_ key: KeyedDecodingContainer<K>.Key) throws -> T? where T : Decodable {
        try decodeIfPresent(T.self, forKey: key)
    }

}
