//
//  LocalizableStrings.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-23.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class LocalizableStrings {
    open class LoadingView {
        open static let RetryButtonTitle = "Försök igen"
        open static let LoadingFailedMessage = "Appen kunde inte hämta data från Apotekets tjänster. Tryck på knappen nedan för att försöka igen."
        open static let VersionTextFormat = "Version %@  © Apoteket %@"
        open static let CopyrightYear = "2015"
    }
    
    open class FirstTimeGuide {
        open static let FirstSlideText = "Välkommen till Mina recept! Här får du koll på dina läkemedel på recept. Har du barn eller andra personer som du brukar hjälpa med receptärenden finns de också inlagda här."
        open static let SecondSlideText = "Logga in och beställ läkemedel direkt eller ta reda på ditt högkostnadssaldo."
        open static let ThirdSlideText = "Hitta fakta om receptläkemedel och se när och var du kan hämta ut dem på apotek."

        open static let FirstSlideTextLastVersion = "Nu kan du se och beställa läkemedel åt andra - via fullmakt eller som vårdnadshavare till barn."
        open static let SecondSlideTextLastVersion = "Växla enkelt mellan olika personers recept genom att välja \"Byt person\" bredvid ditt namn."

        open static let LastSlideButtonText = "Kom igång"
    }
}
