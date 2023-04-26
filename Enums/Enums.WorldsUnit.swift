//
//  Enums.WorldsUnit.swift
//  sugah
//
//  Created by Rodi on 2/6/23.
//

import Foundation
import BackgroundTasks

enum BloodGlucoseUnitByCountries: String {
    case mgdL = "mg/dL"
    case mmolL = "mmol/L"
    case both = "mg/dL, mmol/L"
}


enum BloodGlucoseUnitsInLocalWordsMgdL: String {
    
    case en = "milligrams per deciliter"
    case de = "Milligramm pro Deziliter"
    case ja = "ミリグラム パー　デシリットル"
    case ko = "밀리그램 마다 데시리터"
    case it = "milligrammi per decilitro"
    case es = "miligramos por decilitro"
    case fr = "milligrammes par décilitre"
    case zh = "毫克每分升"
}
enum BloodGlucoseUnitsInLocalWordsMMolL: String {
    
    case en = "millimole per liter"
    case de = "Millimol pro Liter"
    case ja = "ミリモル パー リットル"
    case ko = "리터당밀리몰" // 리터당 밀 리몰
    case it = "Millimoli per litro"
    case es = "Milimoles por litro"
    case fr = "Millimoles par litre"
    case zh = "毫摩爾每升"
}

/*
 
 Austria    mg/dL
 Belgium    mg/dL
 Croatia    mmol/L
 Czech Republic          mmol/L
 Denmark    mmol/L
 Estonia    mmol/L
 Finland    mmol/L
 France    mg/dL
 Germany    mmol/L & mg/dL
 Greece    mg/dL
 Hungary    mmol/L
 Ireland    mmol/L
 Italy    mg/dL
 Latvia    mmol/L
 Lithuania    mmol/L
 Luxembourg    mg/dL
 Malta    mmol/L
 Netherlands    mmol/L
 Poland    mg/dL
 Portugal    mg/dL
 Slovakia    mmol/L
 Slovenia    mmol/L
 Spain    mg/dL
 Sweden    mmol/L
 United Kingdom    mmol/L
 
 */

let nationalBloodGlucoseUnit: [String: BloodGlucoseUnitByCountries] = [
    "Afghanistan": .mgdL,
    "Albania": .mgdL,
    "Algeria": .mgdL,
    "Andorra": .mgdL,
    "Angola": .mgdL,
    "Antigua and Barbuda": .mgdL,
    "Argentina": .mgdL,
    "Armenia": .mgdL,
    "Australia": .mmolL,
    "Austria": .both,  // Both units are used in Austria
    "Azerbaijan": .mgdL,
    "Bahamas": .mgdL,
    "Bahrain": .mgdL,
    "Bangladesh": .mgdL,
    "Barbados": .mgdL,
    "Belarus": .mmolL,
    "Belgium": .both,  // Both units are used in Belgium
    "Belize": .mgdL,
    "Benin": .mgdL,
    "Bhutan": .mgdL,
    "Bolivia": .mgdL,
    "Bosnia and Herzegovina": .mgdL,
    "Botswana": .mgdL,
    "Brazil": .mgdL,
    "Brunei": .mgdL,
    "Bulgaria": .mmolL,
    "Burkina Faso": .mgdL,
    "Burundi": .mgdL,
    "Cambodia": .mgdL,
    "Cameroon": .mgdL,
    "Canada": .mmolL,
    "Cape Verde": .mgdL,
    "Central African Republic": .mgdL,
    "Chad": .mgdL,
    "Chile": .mgdL,
    "China": .mgdL,
    "Colombia": .mgdL,
    "Comoros": .mgdL,
    "Congo": .mgdL,
    "Costa Rica": .mgdL,
    "Cote d'Ivoire": .mgdL,
    "Croatia": .mmolL,
    "Cuba": .mgdL,
    "Cyprus": .mgdL,
    "Czech Republic": .mmolL,
    "Denmark": .both,  // Both units are used in Denmark
    "Djibouti": .mgdL,
    "Dominica": .mgdL,
    "Dominican Republic": .mgdL,
    "Ecuador": .mgdL,
    "Egypt": .mgdL,
    "El Salvador": .mgdL,
    "Equatorial Guinea": .mgdL,
    "Eritrea": .mgdL,
    "Estonia": .mmolL,
    "Ethiopia": .mgdL,
    "Fiji": .mmolL,
    "Finland": .both,  // Both units are used in Finland
    "France": .both,  // Both units are used in France
    "Gabon": .mgdL,
    "Gambia": .mgdL,
    "Georgia": .mgdL,
    "Germany": .both,  // Both units are used in Germany
    "Ghana": .mgdL,
    "Greece": .mmolL,
    "Grenada": .mgdL,
    "Guatemala": .mgdL,
    "Guinea": .mgdL,
    "Guinea-Bissau": .mgdL,
    "Guyana": .mgdL,
    "Haiti": .mgdL,
    "Honduras": .mgdL,
    "Hungary": .mmolL,
    "Iceland": .mmolL,
    "India": .mgdL,
    "Indonesia": .mgdL,
    "Iran": .mgdL,
    "Iraq": .mgdL,
    "Ireland": .mmolL,
    "Israel": .mgdL,
    "Italy": .both,  // Both units are used in Italy
    "Jamaica": .mgdL,
    "Japan": .mgdL,
    "Jordan": .mgdL,
    "Kazakhstan": .mgdL,
    "Kenya": .mgdL,
    "Kiribati": .mgdL,
    "Kosovo": .mgdL,
    "Kuwait": .mgdL,
    "Kyrgyzstan": .mgdL,
    "Laos": .mgdL,
    "Latvia": .mmolL,
    "Lebanon": .mgdL,
    "Lesotho": .mgdL,
    "Liberia": .mgdL,
    "Libya": .mgdL,
    "Liechtenstein": .mmolL,
    "Lithuania": .mmolL,
    "Luxembourg": .mmolL,
    "Macedonia": .mgdL,
    "Madagascar": .mgdL,
    "Malawi": .mgdL,
    "Maldives": .mgdL,
    "Mali": .mgdL,
    "Malta": .mmolL,
    "Marshall Islands": .mgdL,
    "Mauritania": .mgdL,
    "Mauritius": .mgdL,
    "Mexico": .mgdL,
    "Micronesia": .mgdL,
    "Moldova": .mgdL,
    "Monaco": .both,  // Both units are used in Monaco
    "Mongolia": .mgdL,
    "Montenegro": .mgdL,
    "Morocco": .mgdL,
    "Mozambique": .mgdL,
    "Myanmar": .mgdL,
    "Namibia": .mgdL,
    "Nauru": .mgdL,
    "Nepal": .mgdL,
    "Netherlands": .both,  // Both units are used in the Netherlands
    "New Zealand": .mmolL,
    "Nicaragua": .mgdL,
    "Niger": .mgdL,
    "Nigeria": .mgdL,
    "North Korea": .mgdL,
    "Norway": .both,  // Both units are used in Norway
    "Oman": .mgdL,
    "Pakistan": .mgdL,
    "Palau": .mgdL,
    "Panama": .mgdL,
    "Papua New Guinea": .mgdL,
    "Paraguay": .mgdL,
    "Peru": .mgdL,
    "Philippines": .mgdL,
    "Poland": .mmolL,
    "Portugal": .mmolL,
    "Qatar": .mgdL,
    "Romania": .mmolL,
    "Russia": .mmolL,
    "Rwanda": .mgdL,
    "Saint Kitts and Nevis": .mgdL,
    "Saint Lucia": .mgdL,
    "Saint Vincent and the Grenadines": .mgdL,
    "Samoa": .mgdL,
    "San Marino": .both,  // Both units are used in San Marino
    "Sao Tome and Principe": .mgdL,
    "Saudi Arabia": .mgdL,
    "Senegal": .mgdL,
    "Serbia": .mgdL,
    "Seychelles": .mgdL,
    "Sierra Leone": .mgdL,
    "Singapore": .mmolL,
    "Slovakia": .mmolL,
    "Slovenia": .mmolL,
    "Solomon Islands": .mgdL,
    "Somalia": .mgdL,
    "South Africa": .mgdL,
    "South Korea": .mgdL,
    "South Sudan": .mgdL,
    "Spain": .mmolL,
    "Sudan": .mgdL,
    "Suriname": .mgdL,
    "Swaziland": .mgdL,
    "Sweden": .both,  // Both units are used in Sweden
    "Switzerland": .mmolL,
    "Syria": .mgdL,
    "Taiwan": .mgdL,
    "Tajikistan": .mgdL,
    "Tanzania": .mgdL,
    "Thailand": .mgdL,
    "Timor-Leste": .mgdL,
    "Togo": .mgdL,
    "Tonga": .mgdL,
    "Trinidad and Tobago": .mgdL,
    "Tunisia": .mgdL,
    "Turkey": .mgdL,
    "Turkmenistan": .mgdL,
    "Tuvalu": .mgdL,
    "Uganda": .mgdL,
    "Ukraine": .mmolL,
    "United Arab Emirates": .mgdL,
    "United Kingdom": .mmolL,
    "United States": .mgdL,
    "Uruguay": .mgdL,
    "Uzbekistan": .mgdL,
    "Vanuatu": .mgdL,
    "Vatican City": .both,  // Both units are used in Vatican City
    "Venezuela": .mgdL,
    "Vietnam": .mgdL,
    "Yemen": .mgdL,
    "Zambia": .mgdL,
    "Zimbabwe": .mgdL
]
