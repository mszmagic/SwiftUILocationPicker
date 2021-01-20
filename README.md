# SwiftUILocationPicker

<img width="350" alt="image" src="/social-image.png">

これはSwiftUIビューで、ユーザーは場所の名前を入力して位置を特定することができます。また、ユーザーの現在位置を把握し、マップの中心にその位置を表示することも可能です。

(This is a location picker written in SwiftUI. A search bar and a map display are included in the view. English localization is included.)

<img width="350" alt="image" src="/demo-image.gif">

## 場所を特定する方法は？

ユーザーインターフェイスの背景にはマップが表示され、上部には検索バー、下部には結果表示ウィンドウがあります。

ユーザーが検索バーにキーワードを入力してリターンキーをクリックすると、キーボードが表示されなくなります。キーボードが消えると検索が実行され、ビューの下部に検索結果が表示されます。

次に、ユーザーたちは結果アイテムを入力して、それをマップ上に表示するか、または場所を選択するかのオプションを得ることができます。ユーザーが[マップ上に表示]オプションをタップすると、マップは検索結果の場所を中心として配置され、マップの注釈が表示されます。

ユーザーが[場所を選択]するオプションをクリックすると、選択した場所の名前、住所、座標を含むオブジェクト `MKMapItem` とともに、完了ハンドラー `onLocationSelected` が呼び出されます。

## 使用法

```swift
import LocationPicker // 1

@State var showLocationPicker: Bool = false // 2

Button(action: {
    self.showLocationPicker = true
}, label: {
    Text("場所を選択してください")
})
.sheet(isPresented: $showLocationPicker, content: {
    LocationPicker(shouldUseUserCurrentLocation: true, onLocationSelected: { item in
        self.showLocationPicker = false
        self.locationName = item.name ?? "" // 場所の名前
        self.locationAddress = item.placemark.thoroughfare ?? "" // アドレス
        // item.placemark.coordinate // 場所の座標
    }, onCancelled: {
        // これはユーザーがロケーションの選択を取り消したことを意味します。ビューを閉じてください。
        self.showLocationPicker = false
    })
})
```

## コード実装

```swift
public init(shouldUseUserCurrentLocation: Bool, onLocationSelected: @escaping (MKMapItem) -> Void, onCancelled: @escaping () -> Void, initialMapDisplayCoordinate: CLLocationCoordinate2D = .init(latitude: 35.68110, longitude: 139.76687))
```

このビューは `MKLocalSearch` を使って検索を実行します。場所を検索するためのコードは `MapSearchManager.swift` という名前のファイル内にあります。

`LocationPicker` ビューは、それだけでは閉じません。`onLocationSelected` `onCancelled` 関数で特有の関数を呼び出して閉じる必要があります。

`initialMapDisplayCoordinate` パラメータを調整することで、マップの初期位置を変更することもできます。

## インストール方法：

### Swift Package Manager

1. Xcode内からプロジェクトを開く
2. 上部のシステムバーの"File"をクリック
3. "Swift Packages"をクリック、次いで"Add package dependency…"をクリック
4. 以下のURLをペースト：`https://github.com/mszmagic/SwiftUILocationPicker.git`
5. Version: `Up to Next Major 1.0.1 <`
6. "Next"をクリック
7. "Done"をクリック。
8. `import LocationPicker`
