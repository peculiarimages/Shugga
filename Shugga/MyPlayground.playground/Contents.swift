struct SettingsView: View {
    @EnvironmentObject var settings: YourSettingsObservableObject // Replace with your ObservableObject
    
    @State private var someState: YourDataType // Replace with your data type
    
    var body: some View {
        let unixTimeForExpirationPurpose = dateForExpirationPurpose.timeIntervalSince1970
        
        NavigationView {
            VStack {
                NavigationForSettingsView()
                
                if Int(unixTimeForExpirationPurpose) < appExpirationDate {
                    Form {
                        // ...
                    }
                    .navigationBarTitle("Settings")
                    .onAppear {
                        someState = settings.somePublishedVariable // Replace with your published variable
                    }
                } else {
                    AppExpiredSettingsView()
                }
            }
        }
    }
}
