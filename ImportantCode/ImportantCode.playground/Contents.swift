import UIKit

extension Encodable {
    func convertToQueryItems() throws -> [URLQueryItem]? {
        do {
            let encodeObject = try JSONEncoder().encode(self)
            let jsonObject = (try? JSONSerialization.jsonObject(with: encodeObject, options: .allowFragments))
            //print("JSONSerialization done with " + String(describing: jsonObject))
            let jsonDict = jsonObject.flatMap { $0 as? [String: Any?] }
            print("jsonDict " + String(describing: jsonDict))
            var queryItems = [URLQueryItem]()
            jsonDict!.forEach({ (arg0) in
                print("arg0 " + String(describing: arg0))
                if let value = arg0.value as? String, value.count > 0 {
                    queryItems.append(URLQueryItem(name: arg0.key, value: value))
                }
            })
            return queryItems
        } catch {
            print("JSONEncoder unable to encode")
            return nil
        }
    }
}

struct APIData: Encodable {
    var string1: String?
    var string2: String?
    var int1: Int?
}

struct APIRequestData: Encodable {
    var data: APIData
}


var component = URLComponents(string: "https://www.pinterest.com/")
let requestObject = APIRequestData(data: APIData(string1: "name1", string2: nil, int1: 123))
component?.queryItems =  try? requestObject.convertToQueryItems()
print(String(describing: component?.url))
