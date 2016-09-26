import Foundation

//MARK: - Aliases
typealias JSONObject = AnyObject
typealias JSONDictionary = [String : JSONObject]
typealias JSONArray = [JSONDictionary]

// Singleton to retrive data from remote servers

class DataDownloader {
    
    fileprivate let remoteJSONURLString = "https://t.co/K9ziV0z3SJ"
    static let sharedInstance = DataDownloader()
    
    private init() {} //This prevents others from using the default '()'
    
    // function that downloads a file from a server
    func downloadApplicationData() throws -> JSONArray {
        
        // Downloading file from the server
        let jsonURL = URL(string: remoteJSONURLString)
        guard let url = jsonURL else {
            throw ApplicationErrors.invalidJSONURL
        }

        // Reading file content
        let json = try Data(contentsOf: url)
        let jsonArray = try loadFromData(json)
        return jsonArray
    }
    
    // function to validate and read a JSON file data
    func loadFromData(_ data: Data) throws -> JSONArray {
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            throw ApplicationErrors.wrongJSONData
        }
        
        if (jsonData is NSDictionary) {
            guard let jsonDict = jsonData as? JSONDictionary else {
                throw ApplicationErrors.wrongJSONData
            }
            
            return [jsonDict]
            
        } else if (jsonData is NSArray) {
            guard let jsonArr = jsonData as? JSONArray else {
                throw ApplicationErrors.wrongJSONData
            }
            
            return jsonArr
        } else {
            throw ApplicationErrors.unrecognizedJSONData
        }
    }
}


