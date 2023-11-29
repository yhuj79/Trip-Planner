import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("logo").resizable().scaledToFit().frame(width: 400)
            SpinnerCircle().padding(30)
        }
    }
}

struct SpinnerCircle: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color(red: 1.0, green: 0.306, blue: 0.302), lineWidth: 6)
            .frame(width: 50, height: 50)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false), value: UUID())
            .onAppear {
                self.isAnimating = true
            }
    }
}

#Preview {
    SplashView()
}
