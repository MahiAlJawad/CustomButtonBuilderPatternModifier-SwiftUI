//
//  ContentView.swift
//  CustomViewBuilderPatternModifier-SwiftUI
//
//  Created by Mahi Al Jawad on 20/1/24.
//

import SwiftUI
import Combine

struct CustomButton: View {
    // MARK: Text changing properties
    @State private var title: String
    private var titleChangePublisher: AnyPublisher<String?, Never> = .init(Just(nil))
    
    // MARK: Color changing properties
    @State private var color: Color = .blue
    private var colorChangePublisher: AnyPublisher<Color?, Never> = .init(Just(nil)) // As initial color is .blue
    
    
    init(_ text: String = "") {
        self.title = text
    }
    
    var body: some View {
        Button(action: { print("No action") }, label: {
            Text(title)
                .font(.title2)
                .foregroundStyle(.white)
                .padding()
                .frame(width: 180, height: 70)
                .background(color)
                .clipShape(.rect(cornerRadius: 8.0))
                .onReceive(colorChangePublisher, perform: { color in
                    guard let color else { return }
                    self.color = color
                })
                .onReceive(titleChangePublisher, perform: { title in
                    guard let title else { return }
                    self.title = title
                })
        })
        
    }
    
    func colorChangingButton(_ publisher: AnyPublisher<Color?, Never>) -> Self {
        var view = self
        view.colorChangePublisher = publisher
        return view
    }
    
    func titleChangingButton(_ publisher: AnyPublisher<String?, Never>) -> Self {
        var view = self
        view.titleChangePublisher = publisher
        return view
    }
}


struct ContentView: View {
    var body: some View {
        // Setting up title and color changing datasource i.e. the subjects
        // `titleChangingSubject` and `colorChangingSubject` so that
        // they emit color and title changing data through their publisher
        setupTitleChangingButtonDatasource()
        setupColorChangingButtonDatasource()
        
        return VStack {
            // Only title changing button usage using CustomButton view
            CustomButton()
                .titleChangingButton(titleChangingSubject.eraseToAnyPublisher())
            Text("Title changing button")
            Divider()
            
            // Only color changing button usage using CustomButton view
            CustomButton("Custom Button")
                .colorChangingButton(colorChangingSubject.eraseToAnyPublisher())
            Text("Color changing button")
            Divider()
            
            // Normal plain button usage using CustomButton view
            CustomButton("Plain Button")
            Text("Plain button")
            Divider()
            
            // Both color and title changing button usage using CustomButton view through modifier chaining
            CustomButton()
                .titleChangingButton(titleChangingSubject.eraseToAnyPublisher())
                .colorChangingButton(colorChangingSubject.eraseToAnyPublisher())
            Text("Title and color changing button")
        }
    }
    
    // MARK: Title changing button datasource setup
    
    let titleChangingSubject = PassthroughSubject<String?, Never>()
    
    private func setupTitleChangingButtonDatasource() {
        // Sending changed title in every 1 seconds using subject
        var flag = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if flag {
                titleChangingSubject.send("Delete All")
            } else {
                titleChangingSubject.send("Select All")
            }
            flag.toggle()
        }
    }
    
    // MARK: Color changing button datasource setup
    
    let colorChangingSubject = PassthroughSubject<Color?, Never>()
    
    private func setupColorChangingButtonDatasource() {
        // Sending random colors in every 1 sedond using subject
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            withAnimation { // Just to animate the color change
                let randomColor = getRandomColor()
                // Sending random colors to the subject in every 1 second
                colorChangingSubject.send(randomColor)
            }
        }
    }
    
    func getRandomColor() -> Color {
        var colors: [Color] = [.red, .blue, .green, .yellow, .orange, .brown, .cyan, .purple, .indigo, .mint]
        return colors.randomElement() ?? .green
    }
}

#Preview {
    ContentView()
}
