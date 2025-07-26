
import SwiftUI
import ComposableArchitecture


struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            
            Button("Logout") {
                store.send(.setLogout)
            }
            
            Spacer()
            
            Text(store.history.description)
                .frame(height: 50)
            
            if store.isLoading {
                ProgressView()
                    .frame(height: 50)
            } else {
                Text(store.count.description)
                    .font(.title)
                    .frame(height: 50)
            }
            
            Picker("", selection: .init(
                get: { store.step },
                set: { store.send(.setStep($0))} )
            ) {
                Text("1").tag(1)
                Text("5").tag(5)
                Text("10").tag(10)
            }
            .pickerStyle(.segmented)
            
            
            HStack {
                Button("Income") {
                    store.send(.increment)
                }
                .padding()
                .border(.gray)
                
                
                Button("Credit") {
                    store.send(.decrement)
                }
                .padding()
                .border(.gray)
            }
            
            Button(store.isTimerRunning ? "Stop": "Start") {
                store.send(.timerToggle)
            }
            .padding()
            .border(store.isTimerRunning ? .red : .green)
            
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: Binding(
            get: { store.showErrroAlert },
            set: { _ in store.send(.dismissErrorAlert) }
        )) {
            Button("OK") {
                store.send(.dismissErrorAlert)
            }
        } message: {
            Text(store.errorMessage ?? "")
        }
        
    }
}
