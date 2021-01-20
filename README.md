# SwiftUILocationPicker

これはSwiftUIビューで、ユーザーは場所の名前を入力して位置を特定することができます。また、ユーザーの現在位置を把握し、マップの中心にその位置を表示することも可能です。

## 場所を特定する方法は？

ユーザーインターフェイスの背景にはマップが表示され、上部には検索バー、下部には結果表示ウィンドウがあります。

ユーザーが検索バーにキーワードを入力してリターンキーをクリックすると、キーボードが表示されなくなります。キーボードが消えると検索が実行され、ビューの下部に検索結果が表示されます。

次に、ユーザーたちは結果アイテムを入力して、それをマップ上に表示するか、または場所を選択するかのオプションを得ることができます。ユーザーが[マップ上に表示]オプションをタップすると、マップは検索結果の場所を中心として配置され、マップの注釈が表示されます。

ユーザーが[場所を選択]するオプションをクリックすると、選択した場所の名前、住所、座標を含むオブジェクト `MKMapItem` とともに、完了ハンドラー `onLocationSelected` が呼び出されます。その後、ビューは  `presentationMode` を使用することによってそれ自体を閉じます。

## コード実装

このビューは `MKLocalSearch` を使って検索を実行します。場所を検索するためのコードは `MapSearchManager.swift` という名前のファイル内にあります。

## 使用法

```swift
import SwiftUILocationPicker

NavigationLink(
    destination: LocationPicker(shouldUseUserCurrentLocation: true, onLocationSelected: { item in
        self.locationName = item.name ?? ""
        self.locationAddress = item.placemark.thoroughfare ?? ""
        // item.placemark.coordinate
    }),
    label: {
        Text("場所を選択してください")
    })
```


