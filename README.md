# CustomButtonBuilderPatternModifier-SwiftUI

Suppose, you need to make a multipurpose SwiftUI Custom button. 

Purposes: 
1. Your view can show dynamic title based on data you supply
2. Your view can show multiple colors i.e. changing color based on data you supply
3. Your view can show only plain button without feature 1 or 2

### Purpose 1: 
https://github.com/MahiAlJawad/CustomButtonBuilderPatternModifier-SwiftUI/assets/30589979/7dfcb3e1-eafd-494e-b8d0-e5ce6bc27515

### Purpose 2: 
https://github.com/MahiAlJawad/CustomButtonBuilderPatternModifier-SwiftUI/assets/30589979/cddebbd4-3a5a-4c7a-9cc3-0915a62a709e

### Purpose 3:
<img src="https://github.com/MahiAlJawad/CustomButtonBuilderPatternModifier-SwiftUI/assets/30589979/b22aa244-dc4f-44da-a586-1f556b37ea5f" width="300" height="600" />

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

Again, those who wants to use color changing button only they will provide the color changing data supplier 

```swift
CustomButton()
    .colorChangingButton(colorChangingPublisher)
```

> In this case the view will not ask for any other text-changing properties as this view does not need title-changing

If you need both color changing and text changing then you can chain both modifiers one after another:

```swift
CustomButton()
    .titleChangingButton(titleChangingPublisher)
    .colorChangingButton(colorChangingPublisher)
```

Benefit of such implement is:
> You don't need to supply all the properties as argument during view initialization, you only need to supply what you need. SwiftUI primitive views also follow this approach called chaining. When you use `Text("")` they don't ask for `font` or other properties during initialization.
