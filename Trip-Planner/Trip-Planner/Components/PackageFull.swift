import SwiftUI

struct PackageFull: View {
    var results: [PackageResult]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 4) {
                    ForEach(results) { package in
                        NavigationLink(destination: PackageDetail(package: package)) {
                            ZStack(alignment: .topLeading) {
                                AsyncImage(url: package.image_url)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 135)
                                    .clipped()
                                    .overlay (
                                        Rectangle()
                                            .fill(Color.black.opacity(0.25))
                                    )
                                    .overlay(
                                        VStack(alignment: .leading) {
                                            Text(package.country)
                                                .font(.system(size: 20))
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                            Text(package.date_range)
                                                .font(.system(size: 16))
                                                .bold()
                                                .foregroundColor(Color.white)
                                                .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                        }.padding(10),
                                        alignment: .topLeading
                                    )
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            VStack {
                                                Spacer()
                                                Text("₩ \(package.price)")
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundColor(Color.white)
                                                    .shadow(color: .black, radius: 0.7, x: 0.5, y: 0.5)
                                            }
                                        }.padding(10),
                                        alignment: .bottomTrailing
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .padding(4)
                            }
                        }
                    }
                }
                .navigationBarTitle("패키지 리스트")
                .padding(9)
            }
        }
    }
}

struct PackageFull_Previews: PreviewProvider {
    static var previews: some View {
        PackageFull(results: [])
    }
}
