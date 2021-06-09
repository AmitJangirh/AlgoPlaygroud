import Foundation

public struct Endpoints {
    public static let uploadImage = "https://api-dev-scus-demo.azurewebsites.net/api/Image/UploadImage"
    public static let uploadImageWithByteArray = "https://api-dev-scus-demo.azurewebsites.net/api/Image/UploadImageWithByteArray"
    public static let uploadImageMultiPartForm = "https://api-dev-scus-demo.azurewebsites.net/api/Image/UploadImageMultiPartForm"
}

// Use this endpoint for your code challenge.
public struct ChallengeEndpoint {
    public static let multiPart = "https://api-dev-scus-demo.azurewebsites.net/api/Employee/MultiPartCodeChallenge"
}

public struct ImageResponse: Decodable {
    public let path: String
}

public struct ImageRequest: Encodable {
    public let stringAttachment: String?
    public let dataAttachment: Data?
    public let fileName : String
    
    public init(fileName: String, attachment: Data) {
        self.dataAttachment = attachment
        self.stringAttachment = nil
        self.fileName = fileName
    }
    
    public init(fileName: String, attachment: String) {
        self.dataAttachment = nil
        self.stringAttachment = attachment
        self.fileName = fileName
    }
}

public struct HttpUtility {
    
    public init() {}
    
    public func postApiData<T: Decodable>(requestUrl: URL,
                                          requestBody: Data,
                                          resultType: T.Type,
                                          completionHandler: @escaping(_ result: T)-> Void) {
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if(error == nil && data != nil && data?.count != 0) {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
            
        }.resume()
    }
    
    public func postApiDataWithMultipartForm<T:Decodable>(requestUrl: URL,
                                                          request: ImageRequest,
                                                          resultType: T.Type,
                                                          completionHandler:@escaping(_ result: T) -> Void) {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"

        
        let lineBreak = "\r\n"
        
        let boundary = "---------------------------------\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
        
        var requestData = Data()
        
        requestData.append("--\(boundary)\r\n" .data(using: .utf8)!)
        requestData.append("content-disposition: form-data; name=\"attachment\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
        requestData.append(request.stringAttachment!.data(using: .utf8)!)
        
        requestData.append("\(lineBreak)--\(boundary)\r\n" .data(using: .utf8)!)
        requestData.append("content-disposition: form-data; name=\"fileName\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
        requestData.append("\(request.fileName + lineBreak)" .data(using: .utf8)!)
        
        requestData.append("--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
        
        urlRequest.httpBody = requestData
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")

        // let multipartStr = String(decoding: requestData, as: UTF8.self) //to view the multipart form string
        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in
            if(error == nil && data != nil && data?.count != 0) {
                // let dataStr = String(decoding: requestData, as: UTF8.self) //to view the data you receive from the API
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
}
