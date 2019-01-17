import Foundation

final class URLSessionClient {
    func get(_ url: URL, completion: @escaping ((Data?, Error?) -> Void)) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(data, error); return
            }
            guard statusCode == 200 else {
                completion(data, APIError(statusCode: statusCode)); return
            }

            completion(data, error)
        }

        task.resume()
    }
}
