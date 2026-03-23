import SwiftUI

struct RoomFurniture: Identifiable {
    let id = UUID()
    let name: String
    let assetName: String
    var position: CGPoint
}

struct RoomView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showInventory = false

    @State private var furniture: [RoomFurniture] = [
        RoomFurniture(name: "bed", assetName: "furniture_bed", position: CGPoint(x: 70, y: 160)),
        RoomFurniture(name: "bookshelf", assetName: "furniture_bookshelf", position: CGPoint(x: 170, y: 120)),
        RoomFurniture(name: "desk", assetName: "furniture_desk", position: CGPoint(x: 280, y: 140)),
        RoomFurniture(name: "lamp", assetName: "furniture_lamp", position: CGPoint(x: 330, y: 110)),
        RoomFurniture(name: "rug", assetName: "furniture_rug", position: CGPoint(x: 190, y: 260)),
        RoomFurniture(name: "sofa", assetName: "furniture_sofa", position: CGPoint(x: 100, y: 300)),
        RoomFurniture(name: "tea table", assetName: "furniture_tea_table", position: CGPoint(x: 200, y: 310)),
        RoomFurniture(name: "cat", assetName: "furniture_cat", position: CGPoint(x: 260, y: 340)),
        RoomFurniture(name: "plant", assetName: "furniture_plant", position: CGPoint(x: 330, y: 280)),
        RoomFurniture(name: "fireplace", assetName: "furniture_fireplace", position: CGPoint(x: 310, y: 200)),
    ]

    private let allFurniture: [(String, String)] = [
        ("bed", "furniture_bed"), ("desk", "furniture_desk"),
        ("bookshelf", "furniture_bookshelf"), ("plant", "furniture_plant"),
        ("rug", "furniture_rug"), ("lamp", "furniture_lamp"),
        ("cat", "furniture_cat"), ("sofa", "furniture_sofa"),
        ("chair", "furniture_chair"), ("fireplace", "furniture_fireplace"),
        ("window", "furniture_window"), ("painting", "furniture_painting"),
        ("record player", "furniture_record_player"), ("tea table", "furniture_tea_table"),
        ("wardrobe", "furniture_wardrobe"), ("mailbox", "furniture_mailbox"),
    ]

    var body: some View {
        ZStack {
            // Dark background behind room
            Color(red: 0.15, green: 0.13, blue: 0.18).ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("back")
                        }
                        .font(Theme.typeFont(size: 12))
                        .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                    Text("my room")
                        .font(Theme.typeFont(size: 16))
                        .foregroundStyle(.white.opacity(0.9))
                        .tracking(3)
                    Spacer()
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            showInventory.toggle()
                        }
                    } label: {
                        Image(systemName: showInventory ? "xmark" : "plus.square")
                            .font(.system(size: 16))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 12)

                // THE ROOM
                ZStack {
                    // Room shape: back wall + side walls + floor
                    RoomBackground()

                    // Furniture (sorted by Y for depth)
                    let sorted = furniture.sorted { $0.position.y < $1.position.y }
                    ForEach(sorted) { item in
                        if let idx = furniture.firstIndex(where: { $0.id == item.id }) {
                            FreeDragFurniture(item: $furniture[idx])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 420)
                .clipped()

                Spacer()

                // Inventory bar
                if showInventory {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(allFurniture, id: \.0) { name, asset in
                                Button {
                                    furniture.append(
                                        RoomFurniture(
                                            name: name,
                                            assetName: asset,
                                            position: CGPoint(x: 190, y: 260)
                                        )
                                    )
                                } label: {
                                    VStack(spacing: 3) {
                                        Image(asset)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                        Text(name)
                                            .font(Theme.typeFont(size: 7))
                                            .foregroundStyle(.white.opacity(0.6))
                                    }
                                    .frame(width: 56, height: 60)
                                    .background(.white.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .background(Color(red: 0.12, green: 0.10, blue: 0.15))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Room Background (walls + floor)

struct RoomBackground: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height

            // Floor (warm wood color)
            let floorTop: CGFloat = h * 0.22
            let floorPath = Path { p in
                p.move(to: CGPoint(x: 20, y: floorTop))
                p.addLine(to: CGPoint(x: w - 20, y: floorTop))
                p.addLine(to: CGPoint(x: w - 10, y: h))
                p.addLine(to: CGPoint(x: 10, y: h))
                p.closeSubpath()
            }
            context.fill(floorPath, with: .color(Color(red: 0.55, green: 0.42, blue: 0.30)))

            // Floor planks
            for i in 0..<10 {
                let y = floorTop + CGFloat(i) * (h - floorTop) / 10
                let indent = CGFloat(i) * 1.0
                let plankPath = Path { p in
                    p.move(to: CGPoint(x: 20 - indent, y: y))
                    p.addLine(to: CGPoint(x: w - 20 + indent, y: y))
                }
                context.stroke(plankPath, with: .color(.black.opacity(0.1)), lineWidth: 0.5)
            }

            // Back wall
            let wallPath = Path { p in
                p.move(to: CGPoint(x: 10, y: 0))
                p.addLine(to: CGPoint(x: w - 10, y: 0))
                p.addLine(to: CGPoint(x: w - 20, y: floorTop))
                p.addLine(to: CGPoint(x: 20, y: floorTop))
                p.closeSubpath()
            }
            context.fill(wallPath, with: .color(Color(red: 0.65, green: 0.55, blue: 0.50)))

            // Wall shadow at floor line
            let shadowPath = Path { p in
                p.move(to: CGPoint(x: 20, y: floorTop))
                p.addLine(to: CGPoint(x: w - 20, y: floorTop))
                p.addLine(to: CGPoint(x: w - 20, y: floorTop + 6))
                p.addLine(to: CGPoint(x: 20, y: floorTop + 6))
                p.closeSubpath()
            }
            context.fill(shadowPath, with: .color(.black.opacity(0.15)))

            // Wall trim / baseboard
            let trimPath = Path { p in
                p.move(to: CGPoint(x: 20, y: floorTop - 4))
                p.addLine(to: CGPoint(x: w - 20, y: floorTop - 4))
                p.addLine(to: CGPoint(x: w - 20, y: floorTop))
                p.addLine(to: CGPoint(x: 20, y: floorTop))
                p.closeSubpath()
            }
            context.fill(trimPath, with: .color(Color(red: 0.45, green: 0.35, blue: 0.28)))

            // Left wall edge
            let leftWall = Path { p in
                p.move(to: CGPoint(x: 10, y: 0))
                p.addLine(to: CGPoint(x: 20, y: floorTop))
                p.addLine(to: CGPoint(x: 10, y: h))
                p.addLine(to: CGPoint(x: 0, y: h))
                p.addLine(to: CGPoint(x: 0, y: 0))
                p.closeSubpath()
            }
            context.fill(leftWall, with: .color(Color(red: 0.50, green: 0.42, blue: 0.38)))

            // Right wall edge
            let rightWall = Path { p in
                p.move(to: CGPoint(x: w - 10, y: 0))
                p.addLine(to: CGPoint(x: w - 20, y: floorTop))
                p.addLine(to: CGPoint(x: w - 10, y: h))
                p.addLine(to: CGPoint(x: w, y: h))
                p.addLine(to: CGPoint(x: w, y: 0))
                p.closeSubpath()
            }
            context.fill(rightWall, with: .color(Color(red: 0.50, green: 0.42, blue: 0.38)))

            // Window on back wall
            let winX = w * 0.45
            let winY: CGFloat = 15
            let winW: CGFloat = 60
            let winH: CGFloat = floorTop * 0.6
            let windowPath = Path(CGRect(x: winX, y: winY, width: winW, height: winH))
            context.fill(windowPath, with: .color(Color(red: 0.7, green: 0.82, blue: 0.9)))
            context.stroke(windowPath, with: .color(Color(red: 0.40, green: 0.32, blue: 0.26)), lineWidth: 3)
            // Window cross
            let crossH = Path { p in
                p.move(to: CGPoint(x: winX, y: winY + winH / 2))
                p.addLine(to: CGPoint(x: winX + winW, y: winY + winH / 2))
            }
            let crossV = Path { p in
                p.move(to: CGPoint(x: winX + winW / 2, y: winY))
                p.addLine(to: CGPoint(x: winX + winW / 2, y: winY + winH))
            }
            context.stroke(crossH, with: .color(Color(red: 0.40, green: 0.32, blue: 0.26)), lineWidth: 2)
            context.stroke(crossV, with: .color(Color(red: 0.40, green: 0.32, blue: 0.26)), lineWidth: 2)
        }
    }
}

// MARK: - Draggable Furniture

struct FreeDragFurniture: View {
    @Binding var item: RoomFurniture
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Image(item.assetName)
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: 64, height: 64)
            .shadow(color: isDragging ? Theme.lilac.opacity(0.6) : .black.opacity(0.25),
                    radius: isDragging ? 10 : 4, y: isDragging ? 0 : 4)
            .scaleEffect(isDragging ? 1.15 : 1.0)
            .position(
                x: item.position.x + dragOffset.width,
                y: item.position.y + dragOffset.height
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        isDragging = false
                        item.position.x += value.translation.width
                        item.position.y += value.translation.height
                        dragOffset = .zero
                    }
            )
            .animation(.easeOut(duration: 0.15), value: isDragging)
    }
}

#Preview {
    RoomView()
}
