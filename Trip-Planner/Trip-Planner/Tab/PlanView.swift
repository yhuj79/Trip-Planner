import SwiftUI

struct PlanView: View {
    @State var showingSheet = false
    @State var showModal = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                VStack {
                    Spacer()
                    if !showModal {
                        PlanList()
                    }
                    Spacer()
                    Button(action: {
                        self.showingSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("새 일정 생성")
                        }
                        .frame(width: UIScreen.main.bounds.width - 65)
                        .padding(.vertical, 5)
                    }
                    .bold()
                    .font(.system(size: 20))
                    .shadow(color: .gray, radius: 1, x: 0.7, y: 0.7)
                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(12)
                    .confirmationDialog("타이틀", isPresented: $showingSheet) {
                        Button("전체 목록에서 고르기", role: .none) {
                            self.showModal = true
                        }
                        Button("위시리스트에서 고르기", role: .none) {}
                        Button("취소", role: .cancel) {}
                    }
                }
            }
            .sheet(isPresented: self.$showModal) {
                PlanCreateAll(showModal: $showModal)
                    .onAppear {
                        setWindowBackgroundColor(.black)
                    }
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .navigationBarTitle("일정")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Label("Send", systemImage: "person.crop.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Label("Refresh", systemImage: "gearshape")
                    }
                }
            }
        }
    }
    
    private func setWindowBackgroundColor(_ color: UIColor) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.backgroundColor = color
        }
    }
    
}

#Preview {
    PlanView()
}
