import SwiftUI

struct AccommodationFull: View {
    var results: [AccommodationResult]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                    ForEach(results) { accommodation in
                        NavigationLink(destination: AccommodationDetail(accommodation: accommodation)) {
                            ZStack(alignment: .topLeading) {
                                AsyncImage(url: accommodation.image_url)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 135)
                                    .clipped()
                                    .overlay (
                                        Rectangle()
                                            .fill(Color.black.opacity(0.3))
                                    )
                                    .overlay(
                                        VStack(alignment: .leading) {
                                            Text(accommodation.name)
                                                .font(.system(size: 17))
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                            Text("\(accommodation.country) \(accommodation.city_name)")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        }
                                            .padding(10),
                                        alignment: .topLeading
                                    )
                                    .overlay(
                                        HStack {
                                            HStack {
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 12))
                                                    .bold()
                                                    .foregroundColor(Color(hex: 0xFFE400))
                                                Text(String(format: "%.1f", accommodation.score))
                                                    .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                                    .font(.system(size: 14))
                                                    .bold()
                                                    .foregroundColor(Color(hex: 0xFFE400))
                                                    .padding(.leading, -7)
                                            }
                                            Spacer()
                                            Text("₩ \(accommodation.price)")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        }
                                            .padding(10), alignment: .bottomTrailing
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .padding(4)
                            }
                        }
                    }
                }
                .navigationBarTitle("숙소 리스트")
                .padding(9)
            }
        }
    }
}

struct AccommodationFull_Previews: PreviewProvider {
    static var previews: some View {
        AccommodationFull(results: [])
    }
}
