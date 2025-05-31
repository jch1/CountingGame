//
//  FileUtils.swift
//  CountingGame
//
//  Created by Aram Alejandro Zamora Lores on 30.05.25.
//

import Foundation

public func downloadFile(from url: URL, fileName: String, completion: @escaping (URL?, Error?) -> Void) {
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(nil, error)
            return
        }

        guard let data = data else {
            completion(nil, NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"]))
            return
        }

        do {
            // Get the caches directory
            let cachesDirectory = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = cachesDirectory.appendingPathComponent(fileName)

            // Write data to the file
            try data.write(to: fileURL)

            // Done
            completion(fileURL, nil)
        } catch {
            completion(nil, error)
        }
    }

    task.resume()
}
