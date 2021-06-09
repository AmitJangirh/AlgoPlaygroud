/*:
# Documentation: Image Upload
 
 ## Multiple ways of this this
 1. The Base64 way.
 2. The Byte array way.
 3. Multipart/form-data way.
 
 
 ### Base64
 - "content-type" similar to "application/json".
 - The Posy body is set as Base 64 String data

 
 ### Byte array
 - "content-type" similar to "application/json".
 - The Posy body is set as Data bytes
 
 ### Multipart/form-data
 - "content-type" similar to "multipart/form-data".
 - The post body contains multiple parts and each part is divided by a boundary as below diagram
 
 ![Mutlipart form ](MutliPart_form.png)
 
*/


import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

extension UIImage {
    func base64Data() throws -> Data {
        let request = ImageRequest(fileName: "Base64Image", attachment: self.pngData()!.base64EncodedString())
        return try JSONEncoder().encode(request)
    }
    func byteArray() throws -> Data {
        let request = ImageRequest(fileName: "ByteArray", attachment: self.pngData()!)
        return try JSONEncoder().encode(request)
    }
    var mutliFormRequest: ImageRequest {
        return ImageRequest(fileName: "Mutliform", attachment: self.pngData()!)
    }
}
let image = UIImage(named: "MutliPart_form.png")!
let httpUtility = HttpUtility()


struct ImageUploader {
    static func uploadMultiFormData(image: UIImage) {
        let imageRequest = image.mutliFormRequest
        print(imageRequest)
        let url = URL(string: Endpoints.uploadImageMultiPartForm)!
        print(url)
        httpUtility.postApiDataWithMultipartForm(requestUrl: url,
                                                 request: imageRequest,
                                                 resultType: ImageResponse.self) { (response) in
            print("Finshed upload MutliPartForm: \(response)")
        }
    }
    
    static func uploadBase64(image: UIImage) {
        let imageData = try! image.base64Data()
        let url = URL(string: Endpoints.uploadImage)!
        httpUtility.postApiData(requestUrl: url,
                                requestBody: imageData,
                                resultType: ImageResponse.self) { (response) in
            print("Finshed upload Base 64: \(response)")
        }
    }
    
    static func uploadByteArray(image: UIImage) {
        let imageData = try! image.byteArray()
        let url = URL(string: Endpoints.uploadImageWithByteArray)!
        httpUtility.postApiData(requestUrl: url,
                                requestBody: imageData,
                                resultType: ImageResponse.self) { (response) in
            print("Finshed upload byte array: \(response)")
        }
    }
}

ImageUploader.uploadMultiFormData(image: image)
ImageUploader.uploadByteArray(image: image)
ImageUploader.uploadBase64(image: image)
