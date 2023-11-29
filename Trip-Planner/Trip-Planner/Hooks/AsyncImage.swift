import SwiftUI

struct AsyncImage: View {
    @StateObject private var imageLoader = ImageLoader()
    
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ActivityIndicator()
            }
        }
        .onAppear {
            imageLoader.loadImage(from: url)
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                }
            }
            .resume()
        }
    }
}
