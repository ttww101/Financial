
import Foundation
import UIKit

let freeCurrencyApiUrl = "https://free.currencyconverterapi.com"
let freeCurrencyAppKey = "8d6756685754c6ab4389"

enum CurrencyName {
    enum TWD: String {
        case id = "TWD"
        case en = "New Taiwan Dollar"
        case cn = "新台币"
    }
    enum LBP: String {
        case id = "LBP"
        case en = "Lebanese Lira"
        case cn = "黎巴嫩镑"
    }
    enum UZS: String {
        case id = "UZS"
        case en = "Uzbekistani Som"
        case cn = "乌兹别克斯坦苏姆"
    }
    enum BBD: String {
        case id = "BBD"
        case en = "Barbadian Dollar"
        case cn = "巴巴多斯元"
    }
    enum USD: String {
        case id = "USD"
        case en = "United States Dollar"
        case cn = "美元"
    }
    enum HKD: String {
        case id = "HKD"
        case en = "Hong Kong Dollar"
        case cn = "港元"
    }
    enum BAM: String {
        case id = "BAM"
        case en = "Bosnia And Herzegovina Konvertibilna Marka"
        case cn = "波斯尼亚-黑塞哥维那可兑换马克"
    }
    enum SEK: String {
        case id = "SEK"
        case en = "Swedish Krona"
        case cn = "瑞典克朗"
    }
    enum UYU: String {
        case id = "UYU"
        case en = "Uruguayan Peso"
        case cn = "乌拉圭比索"
    }
    enum CNY: String {
        case id = "CNY"
        case en = "Chinese Yuan"
        case cn = "人民币"
    }
    enum VND: String {
        case id = "VND"
        case en = "Vietnamese Dong"
        case cn = "越南盾"
    }
    enum CUP: String {
        case id = "CUP"
        case en = "Cuban Peso"
        case cn = "古巴比索"
    }
    enum AZN: String {
        case id = "AZN"
        case en = "Azerbaijani Manat"
        case cn = "阿塞拜疆马纳特"
    }
    enum FJD: String {
        case id = "FJD"
        case en = "Fijian Dollar"
        case cn = "斐济元"
    }
    enum KES: String {
        case id = "KES"
        case en = "Kenyan Shilling"
        case cn = "肯尼亚先令"
    }
    enum KHR: String {
        case id = "KHR"
        case en = "Cambodian Riel"
        case cn = "柬埔寨瑞尔"
    }
    enum AWG: String {
        case id = "AWG"
        case en = "Aruban Florin"
        case cn = "阿鲁巴弗罗林"
    }
    enum QAR: String {
        case id = "QAR"
        case en = "Qatari Riyal"
        case cn = "卡塔尔里亚尔"
    }
    enum BZD: String {
        case id = "BZD"
        case en = "Belize Dollar"
        case cn = "伯利兹元"
    }
    enum BYR: String {
        case id = "BYR"
        case en = "Belarusian Ruble"
        case cn = "白俄罗斯卢布"
    }
    enum ALL: String {
        case id = "ALL"
        case en = "Albanian Lek"
        case cn = "阿尔巴尼亚列克"
    }
    enum DOP: String {
        case id = "DOP"
        case en = "Dominican Peso"
        case cn = "多米尼加比索"
    }
    enum NZD: String {
        case id = "NZD"
        case en = "New Zealand Dollar"
        case cn = "新西兰元"
    }
    enum KZT: String {
        case id = "KZT"
        case en = "Kazakhstani Tenge"
        case cn = "哈萨克斯坦坚戈"
    }
    enum EGP: String {
        case id = "EGP"
        case en = "Egyptian Pound"
        case cn = "埃及镑"
    }
    enum SGD: String {
        case id = "SGD"
        case en = "Singapore Dollar"
        case cn = "新加坡元"
    }
    enum SRD: String {
        case id = "SRD"
        case en = "Surinamese Dollar"
        case cn = "苏里南元"
    }
    enum XCD: String {
        case id = "XCD"
        case en = "East Caribbean Dollar"
        case cn = "东加勒比元"
    }
    enum MUR: String {
        case id = "MUR"
        case en = "Mauritian Rupee"
        case cn = "毛里求斯卢比"
    }
    enum LVL: String {
        case id = "LVL"
        case en = "Latvian Lats"
        case cn = "拉脱维亚拉特银币"
    }
    enum PAB: String {
        case id = "PAB"
        case en = "Panamanian Balboa"
        case cn = "巴拿马巴波亚"
    }
    enum NAD: String {
        case id = "NAD"
        case en = "Namibian Dollar"
        case cn = "纳米比亚元"
    }
    enum YER: String {
        case id = "YER"
        case en = "Yemeni Rial"
        case cn = "也门里亚尔"
    }
    enum MKD: String {
        case id = "MKD"
        case en = "Macedonian Denar"
        case cn = "马其顿第纳尔"
    }
    enum BGN: String {
        case id = "BGN"
        case en = "Bulgarian Lev"
        case cn = "保加利亚列弗"
    }
    enum CZK: String {
        case id = "CZK"
        case en = "Czech Koruna"
        case cn = "捷克克朗"
    }
    enum KRW: String {
        case id = "KRW"
        case en = "South Korean Won"
        case cn = "韩元"
    }
    enum CHF: String {
        case id = "CHF"
        case en = "Swiss Franc"
        case cn = "瑞士法郎"
    }
    enum ARS: String {
        case id = "ARS"
        case en = "Argentine Peso"
        case cn = "阿根廷比索"
    }
    enum SOS: String {
        case id = "SOS"
        case en = "Somali Shilling"
        case cn = "索马里先令"
    }
    enum ISK: String {
        case id = "ISK"
        case en = "Icelandic Króna"
        case cn = "冰岛克朗"
    }
    enum PYG: String {
        case id = "PYG"
        case en = "Paraguayan Guarani"
        case cn = "巴拉圭瓜拉尼"
    }
    enum KPW: String {
        case id = "KPW"
        case en = "North Korean Won"
        case cn = "朝鲜元"
    }
    enum BWP: String {
        case id = "BWP"
        case en = "Botswana Pula"
        case cn = "博茨瓦纳普拉"
    }
    enum HUF: String {
        case id = "HUF"
        case en = "Hungarian Forint"
        case cn = "匈牙利福林"
    }
    enum ZAR: String {
        case id = "ZAR"
        case en = "South African Rand"
        case cn = "南非兰特"
    }
    enum FKP: String {
        case id = "FKP"
        case en = "Falkland Islands Pound"
        case cn = "福克兰群岛镑"
    }
    enum HRK: String {
        case id = "HRK"
        case en = "Croatian Kuna"
        case cn = "克罗地亚库纳"
    }
    enum ANG: String {
        case id = "ANG"
        case en = "Netherlands Antillean Gulden"
        case cn = "荷属安的列斯盾"
    }
    enum HNL: String {
        case id = "HNL"
        case en = "Honduran Lempira"
        case cn = "洪都拉斯伦皮拉"
    }
    enum GBP: String {
        case id = "GBP"
        case en = "British Pound"
        case cn = "英镑"
    }
    enum PEN: String {
        case id = "PEN"
        case en = "Peruvian Nuevo Sol"
        case cn = "秘鲁索尔"
    }
    enum IRR: String {
        case id = "IRR"
        case en = "Iranian Rial"
        case cn = "伊朗里亚尔"
    }
    enum THB: String {
        case id = "THB"
        case en = "Thai Baht"
        case cn = "泰铢"
    }
    enum RUB: String {
        case id = "RUB"
        case en = "Russian Ruble"
        case cn = "俄罗斯卢布"
    }
    enum CRC: String {
        case id = "CRC"
        case en = "Costa Rican Colon"
        case cn = "哥斯达黎加科朗"
    }
    enum CLP: String {
        case id = "CLP"
        case en = "Chilean Peso"
        case cn = "智利比索"
    }
    enum SCR: String {
        case id = "SCR"
        case en = "Seychellois Rupee"
        case cn = "塞舌尔卢比"
    }
    enum EUR: String {
        case id = "EUR"
        case en = "Euro"
        case cn = "欧元"
    }
    enum LAK: String {
        case id = "LAK"
        case en = "Lao Kip"
        case cn = "老挝基普"
    }
    enum PLN: String {
        case id = "PLN"
        case en = "Polish Zloty"
        case cn = "波兰兹罗提"
    }
    enum RSD: String {
        case id = "RSD"
        case en = "Serbian Dinar"
        case cn = "塞尔维亚第纳尔"
    }
    enum BOB: String {
        case id = "BOB"
        case en = "Bolivian Boliviano"
        case cn = "玻利维亚诺"
    }
    enum JMD: String {
        case id = "JMD"
        case en = "Jamaican Dollar"
        case cn = "牙买加元"
    }
    enum GTQ: String {
        case id = "GTQ"
        case en = "Guatemalan Quetzal"
        case cn = "危地马拉格查尔"
    }
    enum SHP: String {
        case id = "SHP"
        case en = "Saint Helena Pound"
        case cn = "圣赫勒拿镑"
    }
    enum UAH: String {
        case id = "UAH"
        case en = "Ukrainian Hryvnia"
        case cn = "乌克兰格里夫纳"
    }
    enum LRD: String {
        case id = "LRD"
        case en = "Liberian Dollar"
        case cn = "利比里亚元"
    }
    enum BSD: String {
        case id = "BSD"
        case en = "Bahamian Dollar"
        case cn = "巴哈马元"
    }
    enum INR: String {
        case id = "INR"
        case en = "Indian Rupee"
        case cn = "印度卢比"
    }
    enum PKR: String {
        case id = "PKR"
        case en = "Pakistani Rupee"
        case cn = "巴基斯坦卢比"
    }
    enum CAD: String {
        case id = "CAD"
        case en = "Canadian Dollar"
        case cn = "加拿大元"
    }
    enum TZS: String {
        case id = "TZS"
        case en = "Tanzanian Shilling"
        case cn = "坦桑尼亚先令"
    }
    enum OMR: String {
        case id = "OMR"
        case en = "Omani Rial"
        case cn = "阿曼里亚尔"
    }
    enum NPR: String {
        case id = "NPR"
        case en = "Nepalese Rupee"
        case cn = "尼泊尔卢比"
    }
    enum MNT: String {
        case id = "MNT"
        case en = "Mongolian Tugrik"
        case cn = "蒙古图格里克"
    }
    enum TTD: String {
        case id = "TTD"
        case en = "Trinidad and Tobago Dollar"
        case cn = "特立尼达和多巴哥元"
    }
    enum NOK: String {
        case id = "NOK"
        case en = "Norwegian Krone"
        case cn = "挪威克朗"
    }
    enum BYN: String {
        case id = "BYN"
        case en = "New Belarusian Ruble"
        case cn = "白俄罗斯卢布"
    }
    enum LKR: String {
        case id = "LKR"
        case en = "Sri Lankan Rupee"
        case cn = "斯里兰卡卢比"
    }
    enum SYP: String {
        case id = "SYP"
        case en = "Syrian Pound"
        case cn = "叙利亚磅"
    }
    enum ILS: String {
        case id = "ILS"
        case en = "Israeli New Sheqel"
        case cn = "以色列新谢克尔"
    }
    enum BND: String {
        case id = "BND"
        case en = "Brunei Dollar"
        case cn = "文莱元"
    }
    enum UGX: String {
        case id = "UGX"
        case en = "Ugandan Shilling"
        case cn = "乌干达先令"
    }
    enum DKK: String {
        case id = "DKK"
        case en = "Danish Krone"
        case cn = "丹麦克朗"
    }
    enum MYR: String {
        case id = "MYR"
        case en = "Malaysian Ringgit"
        case cn = "马来西亚林吉特"
    }
    enum KGS: String {
        case id = "KGS"
        case en = "Kyrgyzstani Som"
        case cn = "吉尔吉斯斯坦索姆"
    }
    enum PHP: String {
        case id = "PHP"
        case en = "Philippine Peso"
        case cn = "菲律宾比索"
    }
    enum SAR: String {
        case id = "SAR"
        case en = "Saudi Riyal"
        case cn = "沙特里亚尔"
    }
    enum GYD: String {
        case id = "GYD"
        case en = "Guyanese Dollar"
        case cn = "圭亚那元"
    }
    enum NIO: String {
        case id = "NIO"
        case en = "Nicaraguan Cordoba"
        case cn = "尼加拉瓜科多巴"
    }
    enum NGN: String {
        case id = "NGN"
        case en = "Nigerian Naira"
        case cn = "尼日利亚奈拉"
    }
    enum COP: String {
        case id = "COP"
        case en = "Colombian Peso"
        case cn = "哥伦比亚比索"
    }
    enum MXN: String {
        case id = "MXN"
        case en = "Mexican Peso"
        case cn = "墨西哥比索"
    }
    enum KYD: String {
        case id = "KYD"
        case en = "Cayman Islands Dollar"
        case cn = "开曼元"
    }
    enum BRL: String {
        case id = "BRL"
        case en = "Brazilian Real"
        case cn = "巴西雷亚尔"
    }
    enum BTC: String {
        case id = "BTC"
        case en = "Bitcoin"
        case cn = "比特币"
    }
    enum SBD: String {
        case id = "SBD"
        case en = "Solomon Islands Dollar"
        case cn = "所罗门群岛元"
    }
    enum RON: String {
        case id = "RON"
        case en = "Romanian Leu"
        case cn = "罗马尼亚列伊"
    }
    enum IDR: String {
        case id = "IDR"
        case en = "Indonesian Rupiah"
        case cn = "印度尼西亚盾"
    }
    enum JPY: String {
        case id = "JPY"
        case en = "Japanese Yen"
        case cn = "日元"
    }
    enum GIP: String {
        case id = "GIP"
        case en = "Gibraltar Pound"
        case cn = "直布罗陀镑"
    }
    enum AUD: String {
        case id = "AUD"
        case en = "Australian Dollar"
        case cn = "澳大利亚元"
    }
    enum AFN: String {
        case id = "AFN"
        case en = "Afghan Afghani"
        case cn = "阿富汗尼"
    }
}

func getCurrencyNameCn(abbs:String?, id:String) -> String {
    if (id == CurrencyName.TWD.id.rawValue) {
        return CurrencyName.TWD.cn.rawValue
    } else if (id == CurrencyName.LBP.id.rawValue) {
        return CurrencyName.LBP.cn.rawValue
    } else if (id == CurrencyName.UZS.id.rawValue) {
        return CurrencyName.UZS.cn.rawValue
    } else if (id == CurrencyName.BBD.id.rawValue) {
        return CurrencyName.BBD.cn.rawValue
    } else if (id == CurrencyName.USD.id.rawValue) {
        return CurrencyName.USD.cn.rawValue
    } else if (id == CurrencyName.HKD.id.rawValue) {
        return CurrencyName.HKD.cn.rawValue
    } else if (id == CurrencyName.BAM.id.rawValue) {
        return CurrencyName.BAM.cn.rawValue
    } else if (id == CurrencyName.SEK.id.rawValue) {
        return CurrencyName.SEK.cn.rawValue
    } else if (id == CurrencyName.UYU.id.rawValue) {
        return CurrencyName.UYU.cn.rawValue
    } else if (id == CurrencyName.CNY.id.rawValue) {
        return CurrencyName.CNY.cn.rawValue
    } else if (id == CurrencyName.VND.id.rawValue) {
        return CurrencyName.VND.cn.rawValue
    } else if (id == CurrencyName.CUP.id.rawValue) {
        return CurrencyName.CUP.cn.rawValue
    } else if (id == CurrencyName.AZN.id.rawValue) {
        return CurrencyName.AZN.cn.rawValue
    } else if (id == CurrencyName.FJD.id.rawValue) {
        return CurrencyName.FJD.cn.rawValue
    } else if (id == CurrencyName.KES.id.rawValue) {
        return CurrencyName.KES.cn.rawValue
    } else if (id == CurrencyName.KHR.id.rawValue) {
        return CurrencyName.KHR.cn.rawValue
    } else if (id == CurrencyName.AWG.id.rawValue) {
        return CurrencyName.AWG.cn.rawValue
    } else if (id == CurrencyName.QAR.id.rawValue) {
        return CurrencyName.QAR.cn.rawValue
    } else if (id == CurrencyName.BZD.id.rawValue) {
        return CurrencyName.BZD.cn.rawValue
    } else if (id == CurrencyName.BYR.id.rawValue) {
        return CurrencyName.BYR.cn.rawValue
    } else if (id == CurrencyName.ALL.id.rawValue) {
        return CurrencyName.ALL.cn.rawValue
    } else if (id == CurrencyName.DOP.id.rawValue) {
        return CurrencyName.DOP.cn.rawValue
    } else if (id == CurrencyName.NZD.id.rawValue) {
        return CurrencyName.NZD.cn.rawValue
    } else if (id == CurrencyName.KZT.id.rawValue) {
        return CurrencyName.KZT.cn.rawValue
    } else if (id == CurrencyName.EGP.id.rawValue) {
        return CurrencyName.EGP.cn.rawValue
    } else if (id == CurrencyName.SGD.id.rawValue) {
        return CurrencyName.SGD.cn.rawValue
    } else if (id == CurrencyName.SRD.id.rawValue) {
        return CurrencyName.SRD.cn.rawValue
    } else if (id == CurrencyName.XCD.id.rawValue) {
        return CurrencyName.XCD.cn.rawValue
    } else if (id == CurrencyName.MUR.id.rawValue) {
        return CurrencyName.MUR.cn.rawValue
    } else if (id == CurrencyName.LVL.id.rawValue) {
        return CurrencyName.LVL.cn.rawValue
    } else if (id == CurrencyName.PAB.id.rawValue) {
        return CurrencyName.PAB.cn.rawValue
    } else if (id == CurrencyName.NAD.id.rawValue) {
        return CurrencyName.NAD.cn.rawValue
    } else if (id == CurrencyName.YER.id.rawValue) {
        return CurrencyName.YER.cn.rawValue
    } else if (id == CurrencyName.MKD.id.rawValue) {
        return CurrencyName.MKD.cn.rawValue
    } else if (id == CurrencyName.BGN.id.rawValue) {
        return CurrencyName.BGN.cn.rawValue
    } else if (id == CurrencyName.CZK.id.rawValue) {
        return CurrencyName.CZK.cn.rawValue
    } else if (id == CurrencyName.KRW.id.rawValue) {
        return CurrencyName.KRW.cn.rawValue
    } else if (id == CurrencyName.CHF.id.rawValue) {
        return CurrencyName.CHF.cn.rawValue
    } else if (id == CurrencyName.ARS.id.rawValue) {
        return CurrencyName.ARS.cn.rawValue
    } else if (id == CurrencyName.SOS.id.rawValue) {
        return CurrencyName.SOS.cn.rawValue
    } else if (id == CurrencyName.ISK.id.rawValue) {
        return CurrencyName.ISK.cn.rawValue
    } else if (id == CurrencyName.PYG.id.rawValue) {
        return CurrencyName.PYG.cn.rawValue
    } else if (id == CurrencyName.KPW.id.rawValue) {
        return CurrencyName.KPW.cn.rawValue
    } else if (id == CurrencyName.BWP.id.rawValue) {
        return CurrencyName.BWP.cn.rawValue
    } else if (id == CurrencyName.HUF.id.rawValue) {
        return CurrencyName.HUF.cn.rawValue
    } else if (id == CurrencyName.ZAR.id.rawValue) {
        return CurrencyName.ZAR.cn.rawValue
    } else if (id == CurrencyName.FKP.id.rawValue) {
        return CurrencyName.FKP.cn.rawValue
    } else if (id == CurrencyName.HRK.id.rawValue) {
        return CurrencyName.HRK.cn.rawValue
    } else if (id == CurrencyName.ANG.id.rawValue) {
        return CurrencyName.ANG.cn.rawValue
    } else if (id == CurrencyName.HNL.id.rawValue) {
        return CurrencyName.HNL.cn.rawValue
    } else if (id == CurrencyName.GBP.id.rawValue) {
        return CurrencyName.GBP.cn.rawValue
    } else if (id == CurrencyName.PEN.id.rawValue) {
        return CurrencyName.PEN.cn.rawValue
    } else if (id == CurrencyName.IRR.id.rawValue) {
        return CurrencyName.IRR.cn.rawValue
    } else if (id == CurrencyName.THB.id.rawValue) {
        return CurrencyName.THB.cn.rawValue
    } else if (id == CurrencyName.RUB.id.rawValue) {
        return CurrencyName.RUB.cn.rawValue
    } else if (id == CurrencyName.CRC.id.rawValue) {
        return CurrencyName.CRC.cn.rawValue
    } else if (id == CurrencyName.CLP.id.rawValue) {
        return CurrencyName.CLP.cn.rawValue
    } else if (id == CurrencyName.SCR.id.rawValue) {
        return CurrencyName.SCR.cn.rawValue
    } else if (id == CurrencyName.EUR.id.rawValue) {
        return CurrencyName.EUR.cn.rawValue
    } else if (id == CurrencyName.LAK.id.rawValue) {
        return CurrencyName.LAK.cn.rawValue
    } else if (id == CurrencyName.PLN.id.rawValue) {
        return CurrencyName.PLN.cn.rawValue
    } else if (id == CurrencyName.RSD.id.rawValue) {
        return CurrencyName.RSD.cn.rawValue
    } else if (id == CurrencyName.BOB.id.rawValue) {
        return CurrencyName.BOB.cn.rawValue
    } else if (id == CurrencyName.JMD.id.rawValue) {
        return CurrencyName.JMD.cn.rawValue
    } else if (id == CurrencyName.GTQ.id.rawValue) {
        return CurrencyName.GTQ.cn.rawValue
    } else if (id == CurrencyName.SHP.id.rawValue) {
        return CurrencyName.SHP.cn.rawValue
    } else if (id == CurrencyName.UAH.id.rawValue) {
        return CurrencyName.UAH.cn.rawValue
    } else if (id == CurrencyName.LRD.id.rawValue) {
        return CurrencyName.LRD.cn.rawValue
    } else if (id == CurrencyName.BSD.id.rawValue) {
        return CurrencyName.BSD.cn.rawValue
    } else if (id == CurrencyName.INR.id.rawValue) {
        return CurrencyName.INR.cn.rawValue
    } else if (id == CurrencyName.PKR.id.rawValue) {
        return CurrencyName.PKR.cn.rawValue
    } else if (id == CurrencyName.CAD.id.rawValue) {
        return CurrencyName.CAD.cn.rawValue
    } else if (id == CurrencyName.TZS.id.rawValue) {
        return CurrencyName.TZS.cn.rawValue
    } else if (id == CurrencyName.OMR.id.rawValue) {
        return CurrencyName.OMR.cn.rawValue
    } else if (id == CurrencyName.NPR.id.rawValue) {
        return CurrencyName.NPR.cn.rawValue
    } else if (id == CurrencyName.MNT.id.rawValue) {
        return CurrencyName.MNT.cn.rawValue
    } else if (id == CurrencyName.TTD.id.rawValue) {
        return CurrencyName.TTD.cn.rawValue
    } else if (id == CurrencyName.NOK.id.rawValue) {
        return CurrencyName.NOK.cn.rawValue
    } else if (id == CurrencyName.BYN.id.rawValue) {
        return CurrencyName.BYN.cn.rawValue
    } else if (id == CurrencyName.LKR.id.rawValue) {
        return CurrencyName.LKR.cn.rawValue
    } else if (id == CurrencyName.SYP.id.rawValue) {
        return CurrencyName.SYP.cn.rawValue
    } else if (id == CurrencyName.ILS.id.rawValue) {
        return CurrencyName.ILS.cn.rawValue
    } else if (id == CurrencyName.BND.id.rawValue) {
        return CurrencyName.BND.cn.rawValue
    } else if (id == CurrencyName.UGX.id.rawValue) {
        return CurrencyName.UGX.cn.rawValue
    } else if (id == CurrencyName.DKK.id.rawValue) {
        return CurrencyName.DKK.cn.rawValue
    } else if (id == CurrencyName.MYR.id.rawValue) {
        return CurrencyName.MYR.cn.rawValue
    } else if (id == CurrencyName.KGS.id.rawValue) {
        return CurrencyName.KGS.cn.rawValue
    } else if (id == CurrencyName.PHP.id.rawValue) {
        return CurrencyName.PHP.cn.rawValue
    } else if (id == CurrencyName.SAR.id.rawValue) {
        return CurrencyName.SAR.cn.rawValue
    } else if (id == CurrencyName.GYD.id.rawValue) {
        return CurrencyName.GYD.cn.rawValue
    } else if (id == CurrencyName.NIO.id.rawValue) {
        return CurrencyName.NIO.cn.rawValue
    } else if (id == CurrencyName.NGN.id.rawValue) {
        return CurrencyName.NGN.cn.rawValue
    } else if (id == CurrencyName.COP.id.rawValue) {
        return CurrencyName.COP.cn.rawValue
    } else if (id == CurrencyName.MXN.id.rawValue) {
        return CurrencyName.MXN.cn.rawValue
    } else if (id == CurrencyName.KYD.id.rawValue) {
        return CurrencyName.KYD.cn.rawValue
    } else if (id == CurrencyName.BRL.id.rawValue) {
        return CurrencyName.BRL.cn.rawValue
    } else if (id == CurrencyName.BTC.id.rawValue) {
        return CurrencyName.BTC.cn.rawValue
    } else if (id == CurrencyName.SBD.id.rawValue) {
        return CurrencyName.SBD.cn.rawValue
    } else if (id == CurrencyName.RON.id.rawValue) {
        return CurrencyName.RON.cn.rawValue
    } else if (id == CurrencyName.IDR.id.rawValue) {
        return CurrencyName.IDR.cn.rawValue
    } else if (id == CurrencyName.JPY.id.rawValue) {
        return CurrencyName.JPY.cn.rawValue
    } else if (id == CurrencyName.GIP.id.rawValue) {
        return CurrencyName.GIP.cn.rawValue
    } else if (id == CurrencyName.AUD.id.rawValue) {
        return CurrencyName.AUD.cn.rawValue
    } else if (id == CurrencyName.AFN.id.rawValue) {
        return CurrencyName.AFN.cn.rawValue
    } else {
        return ""
    }
}

func getCurrencyObjectArray(abbs:String?, callback: @escaping (_ currencyObjectArray:[CurrencyObject]) -> Void) {
    var headers:[String:String] = [String:String]()
    headers["Content-Type"] = "application/json"
    downloadJasonDataAsDictionary(abbs: nil, url: freeCurrencyApiUrl + "/api/v6/currencies?apiKey=" + freeCurrencyAppKey, type: "GET", headers: headers, uploadDic: nil) { (resultStatus, resultHeaders, resultDic, resultError) in
        
        var currencyArray = [CurrencyObject]()
        
        if let currencyDic = resultDic["results"] as? [String:Any] {
            for i in 0..<Array(currencyDic.keys).count {
                let currencyKey = Array(currencyDic.keys)[i]
                if let dataDic = currencyDic[currencyKey] as? [String:Any] {
                    if let currencyName = dataDic["currencyName"] as? String {
                        if let currencySymbol = dataDic["currencySymbol"] as? String {
                            let currencyObj = CurrencyObject()
                            currencyObj.id = currencyKey
                            currencyObj.currencyName = currencyName
                            currencyObj.currencySymbol = currencySymbol
                            currencyArray.append(currencyObj)
                        }
                    }
                }
            }
        }
        
        callback(currencyArray.sorted { $0.id < $1.id })
        
    }
}

func getCurrencyValue(abbs:String?, fromCurrencyId:String, toCurrencyId:String, callback: @escaping (_ value:Double?) -> Void) {
    
    var headers:[String:String] = [String:String]()
    headers["Content-Type"] = "application/json"
    downloadJasonDataAsDictionary(abbs: nil, url: freeCurrencyApiUrl + "/api/v6/convert?apiKey=" + freeCurrencyAppKey + "&q=" + fromCurrencyId + "_" + toCurrencyId + "&compact=ultra", type: "GET", headers: headers, uploadDic: nil) { (resultStatus, resultHeaders, resultDic, resultError) in
        
        if let currencyValue = resultDic["\(fromCurrencyId)_\(toCurrencyId)"] as? Double {
            callback(currencyValue)
        } else {
            callback(nil)
        }
        
    }
    
}
