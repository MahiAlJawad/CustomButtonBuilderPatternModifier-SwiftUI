# CustomButtonBuilderPatternModifier-SwiftUI

Suppose, you need to make a multipurpose SwiftUI Custom button. 

Purposes: 
1. Your view can show dynamic titles based on data you supply
2. Your view can show multiple colors i.e. changing color based on the data you supply
3. Your view can show only plain buttons without features 1 or 2
4. Your view can show both title-changing and color-changing buttons by chaining both modifiers

## Output

Showing all 4 types of button output for more clarification of the requirement/purpose:

https://github.com/MahiAlJawad/CustomButtonBuilderPatternModifier-SwiftUI/assets/30589979/18b860f5-8411-4a58-ba92-7a211241cd12

## Usage

Now some developers may use the purpose 1 only, some may use 2 only and some others may use the type 3 only.

Now let's say who will use the type-3 (Plain button) only he will use this way

```swift
CustomButton("Custom button")
```
> The view should not ask for other properties such as color or changing text data supplier during plain button initialization.

Those who want to use the changing text button, only they will supply the changing title data supplier as follows:

```swift
CustomButton()
    .titleChangingButton(titleChangingPublisher)
```
The button will follow the provider data supplier i.e. the publisher data for the title.

> In this case the view will not ask for any other color-changing properties as this view does not need color-changing

Again, those who want to use color changing button only they will provide the color-changing data supplier 

```swift
CustomButton("Multicolor button")
    .colorChangingButton(colorChangingPublisher)
```

> In this case the view will not ask for any other text-changing properties as this view does not need title-changing

If you need both color changing and text changing then you can chain both modifiers one after another:

```swift
CustomButton()
    .titleChangingButton(titleChangingPublisher)
    .colorChangingButton(colorChangingPublisher)
```

The benefit of such implementation is:
> You don't need to supply all the properties as arguments during view initialization, you only need to supply what you need. SwiftUI primitive views also follow this approach called chaining. When you use `Text("")` they don't ask for `font` or other properties during initialization.

## CustomButton() implementation

```swift
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
    
    var buttonView: some View {
        Text(title)
            .font(.title2)
            .foregroundStyle(.white)
            .padding()
            .frame(width: 180, height: 70)
            .background(color)
            .clipShape(.rect(cornerRadius: 8.0))
    }
    
    var body: some View {
        Button(action: { print("No action") }, label: {
            buttonView
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
```

It's easy to understand the `buttonView` SwiftUI implementation. 

Let's explain the approach of making custom modifiers to update the state of the class object.
To make the title change modifier which will update the `title` property we need a publisher which is `titleChangePublisher`.
We inject the publisher with the custom modifier as follows: 

```swift
    func titleChangingButton(_ publisher: AnyPublisher<String?, Never>) -> Self {
        var view = self // Old values of the view is copied in a new object
        view.titleChangePublisher = publisher // Updating the publisher with the new publisher
        return view // Returning the view
    }
```

In usage when we use `CustomView().titleChangingButton(<Publisher>)` the we have to pass a publisher which updates the title accordingly.

A similar way we update the color changing. This approach is known as **Builder Pattern**.

Check out the full implementation in the [ContentView.swift](https://github.com/MahiAlJawad/CustomButtonBuilderPatternModifier-SwiftUI/blob/main/CustomButtonBuilderPatternModifier-SwiftUI/ContentView.swift) file.
