

enum WindDirection : String {
    case N ,NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
}

extension WindDirection: CustomStringConvertible  {
    static let all: [WindDirection] = [.N, .NNE, .NE, .ENE, .E, .ESE, .SE, .SSE, .S, .SSW, .SW, .WSW, .W, .WNW, .NW, .NNW]
    init(_ direction: Double) {
        let index = Int((direction + 11.25).truncatingRemainder(dividingBy: 360) / 22.5)
        self = WindDirection.all[index]
    }
    var description: String {
        return rawValue.uppercased()
    }
}
