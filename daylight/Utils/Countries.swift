import Foundation

struct Coordinate {
    let lat: Double
    let lng: Double
}

enum Countries {
    static let coords: [String: Coordinate] = [
        "argentina": Coordinate(lat: -34.6, lng: -58.4),
        "australia": Coordinate(lat: -33.9, lng: 151.2),
        "austria": Coordinate(lat: 48.2, lng: 16.4),
        "belgium": Coordinate(lat: 50.8, lng: 4.4),
        "brazil": Coordinate(lat: -23.5, lng: -46.6),
        "canada": Coordinate(lat: 43.7, lng: -79.4),
        "chile": Coordinate(lat: -33.4, lng: -70.6),
        "china": Coordinate(lat: 39.9, lng: 116.4),
        "colombia": Coordinate(lat: 4.7, lng: -74.1),
        "czech republic": Coordinate(lat: 50.1, lng: 14.4),
        "denmark": Coordinate(lat: 55.7, lng: 12.6),
        "egypt": Coordinate(lat: 30.0, lng: 31.2),
        "finland": Coordinate(lat: 60.2, lng: 24.9),
        "france": Coordinate(lat: 48.9, lng: 2.3),
        "germany": Coordinate(lat: 52.5, lng: 13.4),
        "greece": Coordinate(lat: 37.9, lng: 23.7),
        "hungary": Coordinate(lat: 47.5, lng: 19.0),
        "iceland": Coordinate(lat: 64.1, lng: -21.9),
        "india": Coordinate(lat: 28.6, lng: 77.2),
        "indonesia": Coordinate(lat: -6.2, lng: 106.8),
        "ireland": Coordinate(lat: 53.3, lng: -6.3),
        "israel": Coordinate(lat: 32.1, lng: 34.8),
        "italy": Coordinate(lat: 41.9, lng: 12.5),
        "japan": Coordinate(lat: 35.7, lng: 139.7),
        "kenya": Coordinate(lat: -1.3, lng: 36.8),
        "korea": Coordinate(lat: 37.6, lng: 127.0),
        "mexico": Coordinate(lat: 19.4, lng: -99.1),
        "morocco": Coordinate(lat: 33.9, lng: -6.8),
        "netherlands": Coordinate(lat: 52.4, lng: 4.9),
        "new zealand": Coordinate(lat: -41.3, lng: 174.8),
        "nigeria": Coordinate(lat: 9.1, lng: 7.5),
        "norway": Coordinate(lat: 59.9, lng: 10.8),
        "pakistan": Coordinate(lat: 33.7, lng: 73.0),
        "peru": Coordinate(lat: -12.0, lng: -77.0),
        "philippines": Coordinate(lat: 14.6, lng: 121.0),
        "poland": Coordinate(lat: 52.2, lng: 21.0),
        "portugal": Coordinate(lat: 38.7, lng: -9.1),
        "romania": Coordinate(lat: 44.4, lng: 26.1),
        "russia": Coordinate(lat: 55.8, lng: 37.6),
        "saudi arabia": Coordinate(lat: 24.7, lng: 46.7),
        "singapore": Coordinate(lat: 1.4, lng: 103.8),
        "south africa": Coordinate(lat: -33.9, lng: 18.4),
        "spain": Coordinate(lat: 40.4, lng: -3.7),
        "sweden": Coordinate(lat: 59.3, lng: 18.1),
        "switzerland": Coordinate(lat: 46.9, lng: 7.4),
        "thailand": Coordinate(lat: 13.8, lng: 100.5),
        "turkey": Coordinate(lat: 41.0, lng: 29.0),
        "ukraine": Coordinate(lat: 50.4, lng: 30.5),
        "united kingdom": Coordinate(lat: 51.5, lng: -0.1),
        "united states": Coordinate(lat: 40.7, lng: -74.0),
        "vietnam": Coordinate(lat: 21.0, lng: 105.8),
    ]

    static let allNames: [String] = coords.keys.sorted().map { $0.capitalized }
}
