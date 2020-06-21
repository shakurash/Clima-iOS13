
struct WeatherDecodedData: Decodable {
    
    let city: Name
    let list: [Main]
}

struct Name: Decodable {
    
    let name: String
}

struct Main: Decodable {
    
    let weather: [Id]
    let main: Temp
}

struct Temp: Decodable {
    
    let temp: Double
}

struct Id: Decodable {
    
    let id: Int
    let description: String
}

