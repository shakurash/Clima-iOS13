
struct WeatherModel {
    
    let cityName: String
    let identification: Int
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var getConditionName: String{
    switch identification {
    case 200...232:
        return "cloud.bolt.rain.fill"
    case 300...321:
        return "cloud.sun.rain"
    case 500...531:
        return "cloud.heavyrain.fill"
    case 600...621:
        return "snow.cloud.fill"
    case 701, 721:
        return "sun.haze.fill"
    case 711:
        return "smoke.fill"
    case 731:
        return "DUST"
    case 741:
        return "cloud.fog.fill"
    case 800:
        return "sun.max.fill"
    default:
        return "cloud"
    }
}
}
