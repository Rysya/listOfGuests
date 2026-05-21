import Foundation

enum LoaderManadgerErrors: Error {
    case invalidData
}

protocol LoaderManadgerProtocol {
    func loadGuests() throws -> [Guest]
}

final class LoaderManadger: LoaderManadgerProtocol {
    
    func loadGuests() throws -> [Guest] {
        guard let url = Bundle.main.url(
            forResource: "listGuests",
            withExtension: "json"
        ) else {
            print("JSON file not found")
            throw LoaderManadgerErrors.invalidData
        }
        
        let data = try Data(contentsOf: url)
        
        let decodedGuests = try JSONDecoder().decode(
            [Guest].self,
            from: data
        )
        return decodedGuests
    }
}
