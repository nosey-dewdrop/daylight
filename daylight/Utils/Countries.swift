import Foundation

struct CountryInfo: Identifiable, Hashable {
    let id: String  // ISO code
    let name: String
    let flag: String
    let latitude: Double
    let longitude: Double
}

enum Countries {
    static let all: [CountryInfo] = [
        CountryInfo(id: "TR", name: "Turkey", flag: "🇹🇷", latitude: 39.9334, longitude: 32.8597),
        CountryInfo(id: "US", name: "United States", flag: "🇺🇸", latitude: 37.0902, longitude: -95.7129),
        CountryInfo(id: "GB", name: "United Kingdom", flag: "🇬🇧", latitude: 55.3781, longitude: -3.4360),
        CountryInfo(id: "DE", name: "Germany", flag: "🇩🇪", latitude: 51.1657, longitude: 10.4515),
        CountryInfo(id: "FR", name: "France", flag: "🇫🇷", latitude: 46.2276, longitude: 2.2137),
        CountryInfo(id: "JP", name: "Japan", flag: "🇯🇵", latitude: 36.2048, longitude: 138.2529),
        CountryInfo(id: "KR", name: "South Korea", flag: "🇰🇷", latitude: 35.9078, longitude: 127.7669),
        CountryInfo(id: "BR", name: "Brazil", flag: "🇧🇷", latitude: -14.2350, longitude: -51.9253),
        CountryInfo(id: "CA", name: "Canada", flag: "🇨🇦", latitude: 56.1304, longitude: -106.3468),
        CountryInfo(id: "AU", name: "Australia", flag: "🇦🇺", latitude: -25.2744, longitude: 133.7751),
        CountryInfo(id: "IT", name: "Italy", flag: "🇮🇹", latitude: 41.8719, longitude: 12.5674),
        CountryInfo(id: "ES", name: "Spain", flag: "🇪🇸", latitude: 40.4637, longitude: -3.7492),
        CountryInfo(id: "MX", name: "Mexico", flag: "🇲🇽", latitude: 23.6345, longitude: -102.5528),
        CountryInfo(id: "IN", name: "India", flag: "🇮🇳", latitude: 20.5937, longitude: 78.9629),
        CountryInfo(id: "CN", name: "China", flag: "🇨🇳", latitude: 35.8617, longitude: 104.1954),
        CountryInfo(id: "RU", name: "Russia", flag: "🇷🇺", latitude: 61.5240, longitude: 105.3188),
        CountryInfo(id: "NL", name: "Netherlands", flag: "🇳🇱", latitude: 52.1326, longitude: 5.2913),
        CountryInfo(id: "SE", name: "Sweden", flag: "🇸🇪", latitude: 60.1282, longitude: 18.6435),
        CountryInfo(id: "NO", name: "Norway", flag: "🇳🇴", latitude: 60.4720, longitude: 8.4689),
        CountryInfo(id: "PL", name: "Poland", flag: "🇵🇱", latitude: 51.9194, longitude: 19.1451),
        CountryInfo(id: "PT", name: "Portugal", flag: "🇵🇹", latitude: 39.3999, longitude: -8.2245),
        CountryInfo(id: "AR", name: "Argentina", flag: "🇦🇷", latitude: -38.4161, longitude: -63.6167),
        CountryInfo(id: "CL", name: "Chile", flag: "🇨🇱", latitude: -35.6751, longitude: -71.5430),
        CountryInfo(id: "CO", name: "Colombia", flag: "🇨🇴", latitude: 4.5709, longitude: -74.2973),
        CountryInfo(id: "EG", name: "Egypt", flag: "🇪🇬", latitude: 26.8206, longitude: 30.8025),
        CountryInfo(id: "ZA", name: "South Africa", flag: "🇿🇦", latitude: -30.5595, longitude: 22.9375),
        CountryInfo(id: "TH", name: "Thailand", flag: "🇹🇭", latitude: 15.8700, longitude: 100.9925),
        CountryInfo(id: "VN", name: "Vietnam", flag: "🇻🇳", latitude: 14.0583, longitude: 108.2772),
        CountryInfo(id: "PH", name: "Philippines", flag: "🇵🇭", latitude: 12.8797, longitude: 121.7740),
        CountryInfo(id: "ID", name: "Indonesia", flag: "🇮🇩", latitude: -0.7893, longitude: 113.9213),
        CountryInfo(id: "NZ", name: "New Zealand", flag: "🇳🇿", latitude: -40.9006, longitude: 174.8860),
        CountryInfo(id: "GR", name: "Greece", flag: "🇬🇷", latitude: 39.0742, longitude: 21.8243),
        CountryInfo(id: "CZ", name: "Czech Republic", flag: "🇨🇿", latitude: 49.8175, longitude: 15.4730),
        CountryInfo(id: "AT", name: "Austria", flag: "🇦🇹", latitude: 47.5162, longitude: 14.5501),
        CountryInfo(id: "CH", name: "Switzerland", flag: "🇨🇭", latitude: 46.8182, longitude: 8.2275),
        CountryInfo(id: "IE", name: "Ireland", flag: "🇮🇪", latitude: 53.4129, longitude: -8.2439),
        CountryInfo(id: "FI", name: "Finland", flag: "🇫🇮", latitude: 61.9241, longitude: 25.7482),
        CountryInfo(id: "DK", name: "Denmark", flag: "🇩🇰", latitude: 56.2639, longitude: 9.5018),
        CountryInfo(id: "UA", name: "Ukraine", flag: "🇺🇦", latitude: 48.3794, longitude: 31.1656),
        CountryInfo(id: "RO", name: "Romania", flag: "🇷🇴", latitude: 45.9432, longitude: 24.9668),
    ].sorted(by: { $0.name < $1.name })

    /// O(1) lookup by ISO code
    private static let byCodeMap: [String: CountryInfo] = {
        Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
    }()

    /// O(1) lookup by country name
    private static let byNameMap: [String: CountryInfo] = {
        Dictionary(uniqueKeysWithValues: all.map { ($0.name, $0) })
    }()

    static func find(byCode code: String) -> CountryInfo? {
        byCodeMap[code]
    }

    static func find(byName name: String) -> CountryInfo? {
        byNameMap[name]
    }

    static let languages = [
        "English", "Turkish", "Spanish", "French", "German", "Japanese",
        "Korean", "Portuguese", "Italian", "Chinese", "Russian", "Arabic",
        "Hindi", "Dutch", "Swedish", "Norwegian", "Polish", "Greek",
        "Thai", "Vietnamese", "Indonesian", "Finnish", "Danish", "Czech",
        "Romanian", "Ukrainian"
    ].sorted()

    static let mbtiTypes = [
        "INTJ", "INTP", "ENTJ", "ENTP",
        "INFJ", "INFP", "ENFJ", "ENFP",
        "ISTJ", "ISFJ", "ESTJ", "ESFJ",
        "ISTP", "ISFP", "ESTP", "ESFP"
    ]

    static let zodiacSigns = [
        "Aries", "Taurus", "Gemini", "Cancer",
        "Leo", "Virgo", "Libra", "Scorpio",
        "Sagittarius", "Capricorn", "Aquarius", "Pisces"
    ]
}
