import SwiftUI

struct TSpotFull: View {
    var results: [TSpotResult]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                    ForEach(results) { spot in
                        NavigationLink(destination: TSpotDetail(spot: spot)) {
                            AsyncImage(url: spot.image_url)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 135)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill(Color.black.opacity(0.25))
                                )
                                .overlay(
                                    VStack(alignment: .leading) {
                                        Text(spot.name)
                                            .font(.system(size: 20))
                                            .bold()
                                            .foregroundColor(Color.white)
                                            .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                    }.padding(10)
                                    , alignment: .topLeading
                                )
                                .overlay(
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Text("\(spot.country) \(spot.city_name)")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        }
                                    }.padding(10)
                                    , alignment: .bottomTrailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .padding(4)
                        }
                    }
                }
                .navigationBarTitle("관광지 리스트")
                .padding(9)
            }
        }
    }
}

struct TSpotFull_Previews: PreviewProvider {
    static var previews: some View {
        TSpotFull(results: [])
    }
}
