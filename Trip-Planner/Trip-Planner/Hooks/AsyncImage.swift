import SwiftUI

// 비동기적으로 이미지를 로드하는 뷰
struct AsyncImage: View {
    // 이미지 로딩을 처리하는 ObservableObject 클래스
    @StateObject private var imageLoader = ImageLoader()
    
    // 이미지의 URL 주소
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        Group {
            // 이미지가 로드되면 표시, 그렇지 않으면 ActivityIndicator 표시
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ActivityIndicator()
            }
        }
        .onAppear {
            // 뷰가 나타날 때 이미지 로딩 시작
            imageLoader.loadImage(from: url)
        }
    }
}

// 이미지를 비동기적으로 로드하는 ObservableObject 클래스
class ImageLoader: ObservableObject {
    // 로드된 이미지를 저장하고 변경 사항을 감지하여 뷰에 업데이트
    @Published var image: UIImage?
    
    // 주어진 URL에서 이미지를 로드하는 함수
    func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, let loadedImage = UIImage(data: data) {
                    // 메인 스레드에서 이미지 업데이트
                    DispatchQueue.main.async {
                        self.image = loadedImage
                    }
                }
            }
            .resume()
        }
    }
}
