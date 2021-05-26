import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

protocol APIFetcher {
    func fecthAPI(completion: @escaping (Bool) -> Void)
}

class APIAdapter: APIFetcher {
    let session = URLSession.shared
    
    func fecthAPI(completion: @escaping (Bool) -> Void) {
        let request = URLRequest(url: URL(string: "https://private-anon-07de0ad1a1-gdsc.apiary-mock.com/v1/events/search?q=m")!)
        let dataTask = session.dataTask(with: request) { (data, URLResponse, error) in
            print(data?.count ?? 0)
            completion(false)
        }
        dataTask.resume()
    }
}

extension APIFetcher {
    func fetchAPI(_ fallback: APIFetcher) -> APIFetcher {
        return APIFallbackHandler(primary: self, secondary: fallback)
    }

    func retry() -> APIFetcher {
        return fetchAPI(self)
    }
    
    func retry(count: Int) -> APIFetcher {
        return count == 0 ? self : fetchAPI(self).retry(count: count-1)
    }
}

struct APIFallbackHandler: APIFetcher {
    var primary: APIFetcher
    var secondary: APIFetcher
    
    func fecthAPI(completion: @escaping (Bool) -> Void) {
        print("fallback fecthAPI called")
        primary.fecthAPI { (success) in
            if success {
                completion(success)
            } else {
                secondary.fecthAPI(completion: completion)
            }
        }
    }
}


class ViewModel {
    var service: APIFetcher = APIAdapter()
    
    func start() {
        service = service.retry().retry()
        service.fecthAPI { (success) in
            print(success)
        }
    }
}

let viewModel = ViewModel()
viewModel.start()

//
