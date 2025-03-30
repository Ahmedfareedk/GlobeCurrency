//
//  FileCacheManagerContract.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Combine

protocol FileCacheManagerContract {
    func save<T: Codable & Identifiable>(_ object: T) -> AnyPublisher<Void, Error>
    func fetchAll<T: Codable & Identifiable>() -> AnyPublisher<[T], Error>
    func delete<T: Codable & Identifiable>(_ object: T) -> AnyPublisher<Void, Error>
    var updates: AnyPublisher<Void, Never> { get }
}
