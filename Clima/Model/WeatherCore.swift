import Foundation

protocol WeatherModelDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFailed(_ error: Error)
}

struct WeatherCore {
    
    var delegate: WeatherModelDelegate?
    
    let keyAPI = "3d5a43991b05a53f0fb15991a7509ca4"
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?"
    let celsius = "units=metric"
    
    func callTheWeather(cityName: String){
        let urlName = "\(weatherURL)APPID=\(keyAPI)&q=\(cityName)&\(celsius)"
        retrievWeatherData(url: urlName)
    }
    
    func callTheWeather(latitude: Double, longitude: Double) {
        let urlName = "\(weatherURL)APPID=\(keyAPI)&lat=\(latitude)&lon=\(longitude)&\(celsius)"
        retrievWeatherData(url: urlName)
    }
    
    func retrievWeatherData(url: String){
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, urlresponse, error) in
            if error != nil{
                self.delegate?.didFailed(error!)
                return
            }
            if let safeData = data{
                if let weather = self.parseJSON(weatherData: safeData){
                    self.delegate?.didUpdateWeather(weather)
                    
                }
            }
            }
            task.resume()
        }
    }

    
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedData = try decoder.decode(WeatherDecodedData.self, from: weatherData)
            let id = decodedData.list[0].weather[0].id
            let temp = decodedData.list[0].main.temp
            let city = decodedData.city.name
            
            let weatherObject = WeatherModel(cityName: city, identification: id, temperature: temp)
            return weatherObject
        } catch {
            delegate?.didFailed(error)
            return nil
        }
    }
}

