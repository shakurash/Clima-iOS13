import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherCore = WeatherCore()
    var locationManager = CLLocationManager()
        
    @IBAction func gpsPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBOutlet weak var textFieldLabel: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherCore.delegate = self
        textFieldLabel.delegate = self
        
    }
}

// MARK: - WeatherModelDelegate
extension WeatherViewController: WeatherModelDelegate {
    
    func didUpdateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.getConditionName)
            self.cityLabel.text = weather.cityName
        }
       }

    func didFailed(_ error: Error) {
        print(error)
    }
}

// MARK: = uitextfield

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searhPressed(_ sender: UIButton) {
        print(textFieldLabel.text!)
        textFieldLabel.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        print(textField.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let city = textField.text ?? "Unknown City"
        weatherCore.callTheWeather(cityName: city)
        
        textField.text = ""
        textField.placeholder = "Search"
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Type something"
            return false
        } else {
            return true
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherCore.callTheWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
    
    }
}
