//
// Copyright (c) 2020 shinren.pan@gmail.com All rights reserved.
//

import Foundation

struct Geometry: Codable {
    let type = "Point"
    let coordinates: [Double]
}

struct Feature: Codable, Identifiable {
    let id: String
    let properties: [String: String]
    let type = "Feature"
    let geometry: Geometry
}

struct GeoJSON: Codable {
    let type = "FeatureCollection"
    let areaCode: Int
    let features: [Feature]
}

enum Area: String, CaseIterable {

    case
        Changhua_County,
        Chiayi_City,
        Chiayi_County,
        Hsinchu_City,
        Hsinchu_County,
        Hualien_County,
        Kaohsiung_City,
        Keelung_City,
        Kinmen_County,
        Lienchiang_County,
        Miaoli_County,
        Nantou_County,
        New_Taipei_City,
        Penghu_County,
        Pingtung_County,
        Taichung_City,
        Tainan_City,
        Taipei_City,
        Taitung_County,
        Taoyuan_City,
        Yilan_County,
        Yunlin_County

    var fileName: String {
        "\(rawValue)_Map.geojson"
    }
}

do {
    var features: [Feature] = []

    for fileName in Area.allCases.compactMap({ $0.fileName }) {
        let filePath = "data/" + fileName
        let filePathURL = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: filePathURL)
        let geoJSON = try JSONDecoder().decode(GeoJSON.self, from: data)
        features.append(contentsOf: geoJSON.features)
    }

    let allMap = GeoJSON(areaCode: 0, features: features)
    let savePath = "data/All_City_Map.geojson"
    let saveURL = URL(fileURLWithPath: savePath)
    let saveData = try JSONEncoder().encode(allMap)
    try saveData.write(to: saveURL, options: .atomicWrite)
    print("Success")
    exit(EXIT_SUCCESS)
}
catch {
    print("Failure: \(error.localizedDescription)")
    exit(EXIT_FAILURE)
}
