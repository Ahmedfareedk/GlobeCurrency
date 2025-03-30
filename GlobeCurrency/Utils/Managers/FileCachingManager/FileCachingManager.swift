//
//  FileCachingManager.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 29/03/2025.
//

import Foundation
import Combine

final class FileCacheManager: FileCacheManagerContract {
    private var updatesSubject = PassthroughSubject<Void, Never>()
    private let fileName: String
    private let queue = DispatchQueue(label: "fileCacheQueue", attributes: .concurrent)
    private let subject = PassthroughSubject<Void, Never>()
    var updates: AnyPublisher<Void, Never> { updatesSubject.eraseToAnyPublisher() }

    
    lazy private var cacheDirectoryURL: URL = {
        let cacheDirectoryURL = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        return cacheDirectoryURL.appendingPathComponent("\(fileName).json")
    }()
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func save<T: Codable & Identifiable>(_ object: T) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.queue.async(flags: .barrier) {[weak self] in
                guard let self else { return }
                var allObjects: [T] = loadObjects()
                if let index = allObjects.firstIndex(where: { $0.id == object.id }) {
                    allObjects[index] = object
                } else {
                    allObjects.append(object)
                }
                
                do {
                    try saveObjects(allObjects)
                    updatesSubject.send()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func fetchAll<T: Codable & Identifiable>() -> AnyPublisher<[T], Error> {
        return Future { promise in
            self.queue.async {
                let objects: [T] = self.loadObjects()
                promise(.success(objects))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete<T: Codable & Identifiable>(_ object: T) -> AnyPublisher<Void, Error>{
        return Future { promise in
            self.queue.async(flags: .barrier) {[weak self] in
                guard let self else { return }
                var allObjects: [T] = loadObjects()
                allObjects.removeAll { $0.id == object.id }
                
                do {
                    try saveObjects(allObjects)
                    updatesSubject.send()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
        
    private func loadObjects<T: Codable>() -> [T]  {
        guard let data = try? Data(contentsOf: cacheDirectoryURL),
              let objects = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        return objects
    }
    
    private func saveObjects<T: Codable>(_ objects: [T]) throws  {
        let data = try JSONEncoder().encode(objects)
        try data.write(to: cacheDirectoryURL, options: .atomic)
    }
}
