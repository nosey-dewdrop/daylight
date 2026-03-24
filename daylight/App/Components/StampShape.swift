import SwiftUI

// MARK: - Stamp Shape (perforated edges)

struct StampShape: InsettableShape {
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let notchSize: CGFloat = 1.5
        let notchSpacing: CGFloat = 4.0
        var path = Path()

        path.move(to: CGPoint(x: r.minX, y: r.minY))
        var x = r.minX + notchSpacing
        while x < r.maxX - notchSpacing {
            path.addLine(to: CGPoint(x: x, y: r.minY))
            path.addArc(center: CGPoint(x: x + notchSize, y: r.minY),
                        radius: notchSize, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: true)
            x += notchSpacing
        }
        path.addLine(to: CGPoint(x: r.maxX, y: r.minY))

        var y = r.minY + notchSpacing
        while y < r.maxY - notchSpacing {
            path.addLine(to: CGPoint(x: r.maxX, y: y))
            path.addArc(center: CGPoint(x: r.maxX, y: y + notchSize),
                        radius: notchSize, startAngle: .degrees(270), endAngle: .degrees(90), clockwise: true)
            y += notchSpacing
        }
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY))

        x = r.maxX - notchSpacing
        while x > r.minX + notchSpacing {
            path.addLine(to: CGPoint(x: x, y: r.maxY))
            path.addArc(center: CGPoint(x: x - notchSize, y: r.maxY),
                        radius: notchSize, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
            x -= notchSpacing
        }
        path.addLine(to: CGPoint(x: r.minX, y: r.maxY))

        y = r.maxY - notchSpacing
        while y > r.minY + notchSpacing {
            path.addLine(to: CGPoint(x: r.minX, y: y))
            path.addArc(center: CGPoint(x: r.minX, y: y - notchSize),
                        radius: notchSize, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
            y -= notchSpacing
        }

        path.closeSubpath()
        return path
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}
